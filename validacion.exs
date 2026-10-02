defmodule Validacion do
  @dias_validos 1..6
  @max_kilos 250

  def validar_pesaje(pesaje, recolectores_map, lotes_map) do
    with {:ok, _} <- validar_recolector(pesaje.recolector, recolectores_map),
         {:ok, _} <- validar_lote(pesaje.lote, lotes_map),
         {:ok, _} <- validar_dia(pesaje.dia),
         {:ok, _} <- validar_kilos(pesaje.kilos),
         {:ok, _} <- validar_verdes(pesaje.verdes) do
      {:ok, pesaje}
    end
  end

  defp validar_recolector(codigo, recolectores_map) do
    if Map.has_key?(recolectores_map, codigo),
      do: {:ok, codigo},
      else: {:error, :recolector_desconocido}
  end

  defp validar_lote(id_lote, lotes_map) do
    if Map.has_key?(lotes_map, id_lote), do: {:ok, id_lote}, else: {:error, :lote_desconocido}
  end

  defp validar_dia(dia) when is_integer(dia) and dia in @dias_validos,
    do: {:ok, dia}

  defp validar_dia(_), do: {:error, :dia_invalido}

  defp validar_kilos(kilos) when is_number(kilos) and kilos > 0 and kilos <= @max_kilos,
    do: {:ok, kilos}

  defp validar_kilos(_), do: {:error, :kilos_fuera_de_rango}

  defp validar_verdes(verdes) when is_number(verdes) and verdes >= 0 and verdes <= 100,
    do: {:ok, verdes}

  defp validar_verdes(_), do: {:error, :porcentaje_invalido}
end
