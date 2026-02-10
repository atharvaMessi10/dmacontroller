# DMA Controller – Verilog RTL

## Overview
This project implements a simple DMA (Direct Memory Access) controller in Verilog.  
The controller transfers data from a source memory region to a destination region using a finite state machine and a synchronous memory interface.

## Features
FSM-based control logic (IDLE, READ, WAIT, CAPTURE, WRITE)
Configurable source address, destination address, and transfer length
Explicit wait-state handling for synchronous memory read latency
Separate read and write enable signaling
Fully verified using a behavioral memory model and GTKWave

## Design Notes
Memory reads are modeled as synchronous (1-cycle latency)
A WAIT state is used to align data capture with memory output timing
Non-blocking assignments are used for cycle-accurate behavior

## Simulation
Simulated using Icarus Verilog
Waveforms analyzed using GTKWave

## Files
`rtl/dma.v` – DMA controller RTL
`tb/dma_tb.v` – Testbench

## Tools
Verilog HDL
Icarus Verilog
GTKWave
