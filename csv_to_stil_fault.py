import pandas as pd

# Load CSV (adjust filename if needed)
df = pd.read_csv("crc_fault_output.csv")

# Output STIL file name
stil_file = "crc_fault_vectors.stil"

# STIL Header
stil_header = """STIL 1.0;
Signals {
    "clk" In;
    "data_in[15:0]" In;
    "fault_mask[15:0]" In;
    "fault_value[15:0]" In;
    "crc_out[15:0]" Out;
}
SignalGroups {
    "all" = "clk", "data_in[15:0]", "fault_mask[15:0]", "fault_value[15:0]", "crc_out[15:0]";
}
Timing {
    WaveformTable "default" {
        Period '100ns';
        Waveform "clk" { '0' D; '1' U; }
        Waveform "default" { '0' L; '1' H; }
    }
}
PatternBurst "crc_fault_vectors" {
"""

# Generate patterns
patterns = ""
for _, row in df.iterrows():
    clk = '1'
    data = f"{int(row['Data_in'], 16):016b}"
    fmask = f"{int(row['FaultMask'], 16):016b}"
    fval = f"{int(row['FaultValue'], 16):016b}"
    crc = f"{int(row['CRC_out'], 16):016b}"
    vector = f'    Pattern {int(row["Time_ns"])} {{\n'
    vector += f'        "clk" = {clk};\n'
    vector += f'        "data_in[15:0]" = {data};\n'
    vector += f'        "fault_mask[15:0]" = {fmask};\n'
    vector += f'        "fault_value[15:0]" = {fval};\n'
    vector += f'        "crc_out[15:0]" = {crc};\n'
    vector += f'    }}\n'
    patterns += vector

# STIL Footer
stil_footer = "}\n"

# Write to file
with open(stil_file, "w") as f:
    f.write(stil_header)
    f.write(patterns)
    f.write(stil_footer)

print(f"STIL file generated: {stil_file}")
