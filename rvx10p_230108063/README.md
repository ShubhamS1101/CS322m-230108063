# RVX10-P: Five-Stage Pipelined RISC-V Core

**Author:** <Your Name>  
**Course:** CS322M — Digital Logic and Computer Architecture  
**Instructor:** Dr. Satyajit Das, IIT Guwahati

## Overview
RVX10-P extends our single-cycle RVX10 core into a five-stage pipelined CPU supporting RV32I + 10 custom ALU ops.

## Features
- Standard 5 stages (IF, ID, EX, MEM, WB)
- Full forwarding and hazard detection
- Flush on branch/jump
- x0 constant enforcement
- CPI counters (optional)

## Verification
All programs finish with memory[100] = 25.  
GTKWave confirms overlapping instruction execution.

