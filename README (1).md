# AES Cryptographic Core — RTL-to-GDSII Implementation

A Verilog-based AES cryptographic core taken through an ASIC implementation flow using the SCL 180 nm standard-cell technology. The project covers RTL simulation, logic synthesis, scan-based design-for-testability (DFT), physical design, and generation of a GDSII layout.

> **Project status:** The supplied project archive includes an AES GDSII layout and Innovus geometry/connectivity reports. The available reports show no geometry DRC violations and no connectivity problems or warnings. These checks should not be interpreted as a claim of complete foundry sign-off or silicon validation.

## Project Highlights

- AES core supporting encryption and decryption.
- Verilog RTL with AES S-box, inverse S-box, key-memory/key-expansion, encipher, and decipher modules.
- Functional testbench for AES-128 encryption and decryption using a known test vector.
- Logic synthesis and technology mapping with Cadence Genus.
- DFT/scan-chain work and test-related reporting; Synopsys TetraMAX was used for DFT testing/ATPG work.
- Physical implementation with Cadence Innovus.
- GDSII layout generation and geometry/connectivity checks.

## Design Flow

```text
Verilog RTL
    ↓
RTL Simulation (AES encryption/decryption)
    ↓
Synthesis & Technology Mapping — Cadence Genus
    ↓
DFT / Scan Testing — Synopsys TetraMAX
    ↓
Floorplanning and Power Planning — Cadence Innovus
    ↓
Placement → Clock Tree Synthesis → Routing
    ↓
Geometry (DRC) and Connectivity Checks
    ↓
GDSII Layout
```

The precise handoff between synthesis, scan-chain setup, and ATPG depends on the scripts and tool setup used in the project environment.

## Tools and Technology

| Area | Tool / Technology |
|---|---|
| RTL | Verilog |
| Standard-cell technology | SCL 180 nm |
| Logic synthesis | Cadence Genus |
| DFT / ATPG | Synopsys TetraMAX |
| Physical design | Cadence Innovus |
| Simulation waveform | VCD; viewable with GTKWave |

## Reported Results

| Metric | Reported value |
|---|---:|
| Technology node | SCL 180 nm |
| Synthesized cell count | 12,080 |
| Reported cell area | 453,140.058 µm² |
| Clock period constraint | 20 ns (50 MHz) |
| Reported setup slack | +6.852 ns |
| Registers reported scannable | 2,470 / 2,470 (100%) |
| DFT rule violations | 0 |
| Innovus geometry DRC violations | 0 reported |
| Innovus connectivity check | No problems or warnings reported |
| Layout output | `aes_core.gds` generated |

**Timing note:** The +6.852 ns slack is from the available synthesis timing report. Do not interpret it as proof of final post-route timing closure. Use a successful final post-route timing report if making a post-route timing claim.

**Verification note:** The geometry and connectivity statements refer to the reports included in this project. They do not independently establish complete foundry sign-off, LVS sign-off, or fabrication readiness.

## RTL Modules

The source files in the supplied archive include the following core modules:

- `aes_core.v` — top-level AES core
- `aes_sbox.v` — AES substitution box
- `aes_inv_sbox.v` — inverse substitution box
- `aes_key_mem.v` — key expansion/key memory logic
- `aes_encipher_block.v` — encryption datapath
- `aes_decipher_block.v` — decryption datapath
- `tb_aes_core.v` — testbench for encryption and decryption

## Running the RTL Simulation

The testbench is written in Verilog and creates a VCD waveform named `tb_aes_core.vcd`. A typical Icarus Verilog workflow, after installing the simulator and placing the RTL files in the same directory, is:

```bash
iverilog -g2012 -o aes_sim \
  aes_sbox.v aes_inv_sbox.v aes_key_mem.v \
  aes_encipher_block.v aes_decipher_block.v \
  aes_core.v tb_aes_core.v
vvp aes_sim
```

Open the generated waveform with GTKWave if needed:

```bash
gtkwave tb_aes_core.vcd
```

The testbench checks AES-128 encryption and decryption against known expected values. The expected console output should be reviewed when rerunning the test; a previous waveform or executable alone is not a substitute for rerunning the simulation.

## Repository Structure (Suggested)

```text
.
├── rtl/
│   ├── aes_core.v
│   ├── aes_sbox.v
│   ├── aes_inv_sbox.v
│   ├── aes_key_mem.v
│   ├── aes_encipher_block.v
│   └── aes_decipher_block.v
├── tb/
│   └── tb_aes_core.v
├── constraints/
│   └── aes_core.sdc
├── scripts/
│   ├── genus.cmd
│   └── innovus*.cmd
├── reports/
│   ├── area.rpt
│   ├── timing.rpt
│   ├── dft_rules.rpt
│   ├── scan_chain.rpt
│   ├── aes_core.geom.rpt
│   └── aes_core.conn.rpt
├── results/              # Optional; share only approved outputs
│   └── aes_core.gds
└── README.md
```

This is a suggested clean layout for GitHub; it does not imply the archive is already organized in this structure.

## Recommended GitHub Upload Policy

Before making the repository public, review the project and your institution/foundry/tool agreements. Do **not** upload proprietary or restricted assets, including:

- Foundry/PDK files, standard-cell `.lib` and `.lef` files, technology files, RC models, and licensed collateral.
- Cadence/Synopsys installation files, license data, credentials, or environment-specific configuration.
- Large temporary tool databases such as Innovus `.enc` directories, intermediate databases, caches, and generated binary state files.
- Netlists, SPEF, DEF, GDSII, or other implementation outputs unless you are permitted to redistribute them.

A strong public portfolio repository normally includes the RTL, testbench, clean scripts with machine-specific paths removed, non-confidential constraints, selected text reports, and screenshots of results. If the GDSII or implementation reports are restricted, share screenshots or summarized metrics instead.

## Team

- **Jatin Mehlla**
- **Rudransh Chakraborty**
- **Aditya Mittal**

**Project Mentor:** Kunwar Singh

## Disclaimer

This repository documents an academic/design project. Tool outputs and metrics are specific to the supplied configuration and reports. No claim of silicon fabrication, silicon-level validation, or complete foundry sign-off is made unless supported by additional evidence.
