@echo off

cls

del Elixir.Util.beam

elixirc util.ex

del Elixir.Cliente.beam

elixirc Cliente.ex

del Elixir.Benchmark.beam

elixirc benchmark.ex