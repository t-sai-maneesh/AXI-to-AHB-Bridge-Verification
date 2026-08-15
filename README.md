# AXI-to-AHB Bridge Verification using UVM

## Project Overview

This project focuses on the **verification of an AXI4-to-AHB Bridge** using SystemVerilog and UVM.

The bridge acts as the **Device Under Test (DUT)** and converts transactions from the AXI4 interface to the AHB interface. The verification environment generates AXI transactions, observes the corresponding AHB transactions, and checks whether the bridge performs the conversion correctly.

The UVM-based verification environment is designed to verify **AXI read and write transactions, burst transfers, address mapping, data transfer, response handling, and various normal and corner-case scenarios**.

## Design Under Test

The AXI-to-AHB Bridge performs protocol conversion between:

* AXI4 Master Interface
* AHB Slave Interface

The bridge receives AXI transactions and generates the corresponding AHB transfers.

### Main Functions

* AXI Write Transaction Handling
* AXI Read Transaction Handling
* AXI Address Channel Processing
* AXI Data Channel Processing
* AXI Response Channel Handling
* AXI Burst Transaction Handling
* AHB Address and Data Phase Generation
* AHB Transfer Type Generation
* AHB Read Data Handling
* AHB Response Handling

## Verification Architecture

### TB Architecture

The verification environment follows a **UVM-based layered architecture** consisting of AXI and AHB agents along with a scoreboard, environment, sequences, and functional coverage.

<img width="1059" height="1008" alt="WhatsApp Image 2026-08-15 at 10 56 19 AM" src="https://github.com/user-attachments/assets/64fd216a-1d41-4115-ad3d-3e4119259cd6" />

### AXI Agent

The AXI Agent generates and monitors AXI4 transactions to the bridge.

Functions:

* Generates AXI Read Transactions
* Generates AXI Write Transactions
* Generates Burst Transactions
* Drives AXI Address and Data Channels
* Monitors AXI Transactions
* Collects Read and Write Responses

Components:

* AXI Sequencer
* AXI Driver
* AXI Monitor

### AHB Agent

The AHB Agent represents the AHB side of the bridge and provides the required AHB responses/data to the DUT.

Functions:

* Monitors AHB Address and Control Signals
* Provides AHB Read Data
* Generates AHB Responses
* Monitors AHB Transfer Types
* Checks AHB Transfer Behavior

Components:

* AHB Sequencer
* AHB Driver
* AHB Monitor

## Verification Components

The UVM environment consists of:

* Environment
* AXI Agent
* AHB Agent
* AXI Sequencer
* AXI Driver
* AXI Monitor
* AHB Sequencer
* AHB Driver
* AHB Monitor
* Scoreboard
* Functional Coverage
* Virtual Sequences
* Test Classes

## Verification Methodology

The verification environment uses **constrained-random stimulus** to generate different AXI transactions and verify the corresponding AHB transfers.

The scoreboard compares the expected AXI transaction behavior with the observed bridge output and AHB-side activity.

Waveform analysis and simulation debugging are performed to identify protocol and data-transfer issues.

## Test Scenarios

### AXI Write Scenarios

* Single Write Transaction
* Multiple Write Transactions
* Burst Write Transactions
* Different Write Addresses
* Different Write Data
* Write Response Verification

### AXI Read Scenarios

* Single Read Transaction
* Multiple Read Transactions
* Burst Read Transactions
* Different Read Addresses
* Read Data Verification
* Read Response Verification

### Burst Scenarios

* AXI Burst Transactions
* Different Burst Lengths
* Different Burst Sizes
* Sequential Burst Transfers
* Multiple Data Transfers within a Burst

### Corner-Case Scenarios

* Back-to-Back Transactions
* Read After Write
* Write After Read
* Multiple Consecutive Transactions
* Different HREADY Conditions
* AHB Response Handling
* Boundary and Burst Transfer Scenarios

## Functional Coverage

Functional coverage is implemented to measure the verification progress and ensure that important AXI and AHB transaction scenarios are exercised.

Coverage includes:

* AXI Read/Write Transactions
* Burst Length
* Burst Size
* Address Transactions
* AHB Transfer Types
* Read/Write Operations
* Response Conditions
* Different Transaction Combinations

## Scoreboard

The scoreboard performs transaction-level checking between the AXI side and AHB side.

It verifies:

* Address Conversion
* Read Data
* Write Data
* Transaction Direction
* Burst Information
* Transaction Ordering
* Response Handling

## Directory Structure

```text
rtl/                    RTL Design Files, Interfaces

tb/                     UVM Environment, Scoreboard, Top

test/                   UVM Test Cases

axi_rst_agent_top/          AXI RST Agent Components

ahb_rst_agent_top/          AHB RST Agent Components

axi_agent_top/          AXI Agent Components
                        ├── AXI Sequencer
                        ├── AXI Driver
                        └── AXI Monitor

ahb_agent_top/          AHB Agent Components
                        ├── AHB Sequencer
                        ├── AHB Driver
                        └── AHB Monitor

sim/                    Simulation Files
                        └── Makefile
```

## Tools & Technologies

* Verilog
* SystemVerilog
* UVM
* AXI4 Protocol
* AHB-Lite Protocol
* QuestaSim
* VCS
* Git
* GitHub

## Results

* Successfully verified AXI4-to-AHB bridge functionality using UVM.
* Developed reusable AXI and AHB verification agents.
* Verified AXI read and write transactions.
* Verified burst transaction scenarios.
* Implemented constrained-random stimulus generation.
* Implemented scoreboard-based transaction checking.
* Implemented functional coverage.
* Performed waveform-based debugging and protocol analysis.
* Verified normal and corner-case transaction scenarios.

## Waveform

<img width="1920" height="1008" alt="Screenshot 2026-08-12 121223" src="https://github.com/user-attachments/assets/51daf2a6-8479-43c0-9a05-d12a7a3d59e4" />
<img width="1920" height="1008" alt="Screenshot 2026-08-12 121313" src="https://github.com/user-attachments/assets/c52a8d3c-a011-46ba-bb98-7e131a2dfe55" />
<img width="1920" height="1008" alt="Screenshot 2026-08-12 121354" src="https://github.com/user-attachments/assets/d8a9104c-5b27-4f4b-84b4-6f453f621185" />
<img width="1920" height="1008" alt="Screenshot 2026-08-12 121415" src="https://github.com/user-attachments/assets/2f1116da-a3f0-4023-bfcb-9f720b51bed3" />


## Functional Coverage

<img width="1920" height="1008" alt="Screenshot 2026-08-12 121738" src="https://github.com/user-attachments/assets/aef83164-e9ca-461d-ac70-ad0bc4a21181" />
<img width="1920" height="1008" alt="Screenshot 2026-08-12 121824" src="https://github.com/user-attachments/assets/6ad9adb0-c483-4171-a5df-f9a26ab924bd" />


## Terminal Output

<img width="1920" height="1080" alt="Screenshot 2026-08-12 121930" src="https://github.com/user-attachments/assets/22d4a2b2-f449-46ad-9f34-ae445853646e" />
<img width="1920" height="1080" alt="Screenshot 2026-08-12 121938" src="https://github.com/user-attachments/assets/d8e4977a-cda9-4c3d-b8d5-caa071b9519d" />

## Conclusion

This project provided hands-on experience in **AMBA protocol verification, AXI4 and AHB-Lite transaction flow, UVM-based verification, constrained-random testing, scoreboard implementation, functional coverage, and waveform debugging**.

The project strengthened my understanding of **protocol conversion and reusable UVM verification environments**, providing practical experience relevant to **ASIC Design and Functional Verification**.
