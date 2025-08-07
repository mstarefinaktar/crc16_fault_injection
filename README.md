#  CRC16 Fault Injection (Verilog)

This project demonstrates how to inject **bit-level faults** into input data for a **16-bit parallel CRC generator**, and observe the effect on the CRC output. It's intended for use in **IC reliability testing**, **fault modeling**, and **DFT exploration**.

---

## 📁 Files

```

├── crc16\_fault.v                  # CRC module with fault\_mask and fault\_value
├── testbench\_fault\_model.sv      # Testbench with manually defined fault cases
├── crc\_fault\_output.csv          # Output: CRC result for each test vector with faults
├── crc\_fault\_output.stil         # STIL pattern generated from CSV for ATE testing
├── csv\_to\_stil\_fault.py          # Python script to convert CRC CSV into STIL format
└── README.md                     # Project overview

````

---

## 📐 How It Works

- `fault_mask`: Bit positions to inject faults into (`1` means fault applied).
- `fault_value`: For each `1` in the mask, this defines stuck-at-0 or stuck-at-1 behavior.
- The CRC is then computed on the **fault-injected input**.

---

## ▶️ Run Simulation (using Icarus Verilog)

```bash
iverilog -g2012 crc16_fault.v testbench_fault_model.sv
vvp a.out
````

This will produce `crc_fault_output.csv` with results like:

```
Time_ns,Data_in,FaultMask,FaultValue,CRC_out
15000,ABCD,0000,0000,FFFF
35000,1234,0008,0000,FFFE
...
```

---

## 🧪 Generate STIL Patterns

Use the Python script to convert CSV results to ATE-compatible STIL format:

```bash
python csv_to_stil_fault.py
```

This creates `crc_fault_output.stil` for use with pattern-based test systems.

---

## 🎯 Use Cases

* Fault injection and **bit-level test evaluation**
* STIL pattern generation for ATE
* CRC logic **fault tolerance analysis**
* Intro to **DFT and reliability modeling**

---

## 📄 License

MIT License – Free for academic, research, and commercial use with attribution.

