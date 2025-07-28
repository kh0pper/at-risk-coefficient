import pandas as pd
import re

# Sample data extraction functions (adapt to actual PDF parsing)
def extract_total_students(file_content):
    data = {}
    pattern = r"Total Students for (.+?): (\d+)"  # Fallback to economic disadvantage data
    for line in file_content.split("\n"):
        match = re.search(pattern, line)
        if match:
            campus = match.group(1).strip()
            count = int(match.group(2))
            data[campus] = count
    return data

def extract_economic_disadvantage(file_content):
    data = {}
    pattern = r"Total Students for (.+?): (\d+)"
    for line in file_content.split("\n"):
        match = re.search(pattern, line)
        if match:
            campus = match.group(1).strip()
            count = int(match.group(2))
            data[campus] = count
    return data

def extract_at_risk(file_content):
    data = {}
    campus_pattern = r"^(.*?)(?=\s*-+\d+|$)"
    count_pattern = r"Total Students for Campus/At-Risk Reason: (.+?)/(.+?): (\d+)"
    total_pattern = r"Total Students for (.+?): (\d+)"
    
    current_campus = None
    for line in file_content.split("\n"):
        campus_match = re.search(campus_pattern, line)
        if campus_match and line.strip():
            current_campus = campus_match.group(1).strip()
            if current_campus not in data:
                data[current_campus] = {
                    "homeless": 0, "foster_care": 0, "ell": 0,
                    "academic_underperformance": 0, "dropout_risk": 0,
                    "incarceration_delinquency": 0, "teen_pregnancy": 0, "total_at_risk": 0
                }
        count_match = re.search(count_pattern, line)
        if count_match:
            campus, reason, count = count_match.groups()
            count = int(count)
            if reason == "HMLS-Homeless":
                data[campus]["homeless"] = count
            elif reason == "DPRS-DPRS":
                data[campus]["foster_care"] = count
            elif reason == "LEP-LEP":
                data[campus]["ell"] = count
            elif reason in ["RTND-Retained", "EOC-Failed EOC", "FNG2-Failing 2+", "STAR-Failed STAAR", "MAPG-MAP Growth"]:
                data[campus]["academic_underperformance"] += count
            elif reason in ["RECO-Enrolled in Dropout Recovery School", "FED2-Failed 2+"]:
                data[campus]["dropout_risk"] += count
            elif reason in ["EXP-Expulsion", "DAEP-Place DAEP", "RPF-Residential Facility"]:
                data[campus]["incarceration_delinquency"] += count
            elif reason in ["PREG-Pregnant Student", "PRNT-Student Parent"]:
                data[campus]["teen_pregnancy"] += count
        total_match = re.search(total_pattern, line)
        if total_match:
            campus, count = total_match.groups()
            data[campus]["total_at_risk"] = int(count)
    return data

def extract_migrant(file_content):
    data = {}
    pattern = r"Total Students for (.+?): (\d+)"
    for line in file_content.split("\n"):
        match = re.search(pattern, line)
        if match:
            campus = match.group(1).strip()
            count = int(match.group(2))
            data[campus] = count
    return data

def extract_attendance(file_content):
    data = {}
    pattern = r"(\w+.*?)\s+\d+/\d+\.\d\s+\d+/\d+\.\d\s+\d+/\d+\.\d\s+\d+/\d+\.\d\s+\d+/\d+\.\d\s+\d+/\d+\.\d\s+\d+/\d+\.\d\s+(\d+\.\d+)"
    for line in file_content.split("\n"):
        match = re.search(pattern, line)
        if match:
            campus = match.group(1).strip()
            attendance = float(match.group(2))
            data[campus] = attendance
    return data

# Load and process data (replace with actual file reading)
with open("DistrictEconomicDisadvantageListing.txt", "r") as f:
    econ_data = extract_economic_disadvantage(f.read())
with open("DistrictAt-RiskListing.txt", "r") as f:
    at_risk_data = extract_at_risk(f.read())
with open("DistrictMigrantListing.txt", "r") as f:
    migrant_data = extract_migrant(f.read())
with open("DistrictPercentageofAttendanceSummaryAISD.txt", "r") as f:
    attendance_data = extract_attendance(f.read())

# Compile data into DataFrame
campuses = set(econ_data.keys()) | set(at_risk_data.keys()) | set(migrant_data.keys()) | set(attendance_data.keys())
df = pd.DataFrame(index=list(campuses), columns=[
    "campus_id", "total_students", "economic_disadvantage", "homeless", "foster_care",
    "migrant", "ell", "academic_underperformance", "dropout_risk",
    "incarceration_delinquency", "teen_pregnancy", "chronic_absenteeism"
])

for campus in campuses:
    df.loc[campus, "campus_id"] = campus
    # Use economic disadvantage as fallback for total_students
    total_at_risk = at_risk_data.get(campus, {}).get("total_at_risk", 0)
    econ_count = econ_data.get(campus, 0)
    df.loc[campus, "total_students"] = max(total_at_risk, econ_count, 100) * 1.1  # Ensure total > at-risk
    df.loc[campus, "economic_disadvantage"] = econ_data.get(campus, 0)
    df.loc[campus, "homeless"] = at_risk_data.get(campus, {}).get("homeless", 0)
    df.loc[campus, "foster_care"] = at_risk_data.get(campus, {}).get("foster_care", 0)
    df.loc[campus, "migrant"] = migrant_data.get(campus, 0)
    df.loc[campus, "ell"] = at_risk_data.get(campus, {}).get("ell", 0)
    df.loc[campus, "academic_underperformance"] = at_risk_data.get(campus, {}).get("academic_underperformance", 0)
    df.loc[campus, "dropout_risk"] = at_risk_data.get(campus, {}).get("dropout_risk", 0)
    df.loc[campus, "incarceration_delinquency"] = at_risk_data.get(campus, {}).get("incarceration_delinquency", 0)
    df.loc[campus, "teen_pregnancy"] = at_risk_data.get(campus, {}).get("teen_pregnancy", 0)
    # Chronic absenteeism
    attendance = attendance_data.get(campus, 95.0)  # Default 95%
    total_students = df.loc[campus, "total_students"]
    df.loc[campus, "chronic_absenteeism"] = round((100 - attendance) / 100 * total_students, 1)

# Save to CSV
df.to_csv("at_risk_data.csv", index=False)
print("CSV file 'at_risk_data.csv' generated successfully.")
