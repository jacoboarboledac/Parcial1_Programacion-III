#!/usr/bin/bash

clear

rm Elixir.Util.beam

elixirc util.ex

rm Elixir.Cliente.beam

elixirc Cliente.ex

rm Elixir.Benchmark.beam

elixirc benchmark.ex