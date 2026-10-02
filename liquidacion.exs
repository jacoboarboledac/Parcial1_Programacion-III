defmodule Liquidacion do
  @tarifa_base 1000
  @kilos_bonificacion 120
  @bonificacion_diaria 8000
  @descuento_alimentacion 12000

  def calcular_valor_pesaje(pesaje) do
    factor =
      cond do
        pesaje.verdes <= 2.0 -> 1.05
        pesaje.verdes <= 5.0 -> 1.00
        pesaje.verdes <= 10.0 -> 0.90
        true -> 0.70
      end

    pesaje.kilos * @tarifa_base * factor
  end

  def liquidar_recolector(recolector, pesajes_validos) do
    pesajes_rec =
      Enum.filter(
        pesajes_validos,
        &(&1.recolector == recolector.codigo)
      )

    suma_pesajes =
      pesajes_rec
      |> Enum.map(&calcular_valor_pesaje/1)
      |> Enum.sum()

    kilos_totales =
      pesajes_rec
      |> Enum.map(& &1.kilos)
      |> Enum.sum()

    pesajes_por_dia =
      Enum.group_by(pesajes_rec, & &1.dia)

    bonificaciones =
      Enum.reduce(1..6, 0, fn dia, acc ->
        kilos_dia =
          pesajes_por_dia
          |> Map.get(dia, [])
          |> Enum.map(& &1.kilos)
          |> Enum.sum()

        if kilos_dia >= @kilos_bonificacion do
          acc + @bonificacion_diaria
        else
          acc
        end
      end)

    dias_trabajados =
      Map.keys(pesajes_por_dia)
      |> length()

    descuento_alim =
      if recolector.alimentacion do
        dias_trabajados * @descuento_alimentacion
      else
        0
      end

    neto =
      suma_pesajes + bonificaciones - descuento_alim

    %{
      codigo: recolector.codigo,
      nombre: recolector.nombre,
      kilos: kilos_totales,
      suma_pesajes: suma_pesajes,
      bonificaciones: bonificaciones,
      alimentacion: descuento_alim,
      neto: neto,
      dias_trabajados: dias_trabajados,
      pesajes_por_dia: pesajes_por_dia
    }
  end
end
