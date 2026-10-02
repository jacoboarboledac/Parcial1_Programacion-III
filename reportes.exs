defmodule Reportes do
  @meta_diaria 400

  def r1(pesajes_rechazados) do
    encabezado =
      "REPORTE 1: PESAJES RECHAZADOS\n" <>
        String.duplicate("=", 80)

    tabla_hdr =
      "  " <>
        String.pad_trailing("Recolector", 12) <>
        " | " <>
        String.pad_trailing("Lote", 8) <>
        " | " <>
        String.pad_trailing("Día", 8) <>
        " | " <>
        String.pad_leading("Kilos", 10) <>
        " | " <>
        String.pad_leading("Verdes", 8) <>
        " | Motivo de rechazo\n" <>
        String.duplicate("-", 80)

    lineas =
      Enum.map(pesajes_rechazados, fn {p, motivo} ->
        rec = String.pad_trailing(to_string(p.recolector), 12)
        lote = String.pad_trailing(to_string(p.lote), 8)
        dia = "Día #{p.dia}" |> String.pad_trailing(8)
        kilos = String.pad_leading("#{numero(p.kilos)} kg", 10)
        verdes = String.pad_leading("#{numero(p.verdes)}%", 8)

        "  #{rec} | #{lote} | #{dia} | #{kilos} | #{verdes} | #{motivo}"
      end)

    conteo =
      pesajes_rechazados
      |> Enum.map(fn {_, m} -> m end)
      |> Enum.frequencies()

    resumen =
      Enum.map(
        [
          :recolector_desconocido,
          :lote_desconocido,
          :dia_invalido,
          :kilos_fuera_de_rango,
          :porcentaje_invalido
        ],
        fn m ->
          cnt = Map.get(conteo, m, 0)
          "  • #{String.pad_trailing(to_string(m), 25)}: #{cnt}"
        end
      )

    encabezado <>
      "\n" <>
      tabla_hdr <>
      "\n" <>
      Enum.join(lineas, "\n") <>
      "\n\nResumen de rechazos por motivo:\n" <>
      Enum.join(resumen, "\n")
  end

  def r2(lotes, pesajes_validos) do
    pesajes_por_lote =
      Enum.group_by(pesajes_validos, & &1.lote)

    lineas =
      lotes
      |> Enum.map(fn lote ->
        kilos =
          pesajes_por_lote
          |> Map.get(lote.id, [])
          |> Enum.map(& &1.kilos)
          |> Enum.sum()

        rendimiento = kilos / lote.hectareas

        %{
          nombre: lote.nombre,
          kilos: kilos,
          ha: lote.hectareas,
          rend: rendimiento
        }
      end)
      |> Enum.sort_by(& &1.rend, :desc)
      |> Enum.map(fn l ->
        nom = String.pad_trailing(l.nombre, 18)
        k = String.pad_leading("#{numero(l.kilos)} kg", 12)
        ha = String.pad_leading("#{numero(l.ha)} ha", 10)
        rend = String.pad_leading("#{numero(l.rend)} kg/ha", 14)

        "  #{nom} | #{k} | #{ha} | #{rend}"
      end)

    encabezado =
      "REPORTE 2: KILOS Y RENDIMIENTO POR LOTE\n" <>
        String.duplicate("=", 80)

    tabla_hdr =
      "  " <>
        String.pad_trailing("Lote", 18) <>
        " | " <>
        String.pad_leading("Kilos Totales", 12) <>
        " | " <>
        String.pad_leading("Área", 10) <>
        " | " <>
        String.pad_leading("Rendimiento", 14) <>
        "\n" <>
        String.duplicate("-", 80)

    encabezado <>
      "\n" <>
      tabla_hdr <>
      "\n" <>
      Enum.join(lineas, "\n")
  end

  def r3(pesajes_validos) do
    pesajes_por_dia =
      Enum.group_by(pesajes_validos, & &1.dia)

    dias_info =
      Enum.map(1..6, fn dia ->
        kilos =
          pesajes_por_dia
          |> Map.get(dia, [])
          |> Enum.map(& &1.kilos)
          |> Enum.sum()

        cumpliometa = kilos >= @meta_diaria

        {dia, kilos, cumpliometa}
      end)

    lineas =
      Enum.map(dias_info, fn {d, k, c} ->
        estado =
          if c do
            "[CUMPLIÓ META]"
          else
            "[NO CUMPLIÓ META]"
          end

        k_str =
          String.pad_leading("#{numero(k)} kg", 12)

        "  Día #{d}: #{k_str}  ->  #{estado}"
      end)

    todos =
      Enum.all?(dias_info, fn {_, _, c} ->
        c
      end)

    al_menos_uno =
      Enum.any?(dias_info, fn {_, _, c} ->
        c
      end)

    encabezado =
      "REPORTE 3: KILOS RECOLECTADOS POR DÍA (Meta diaria: #{numero(@meta_diaria)} kg)\n" <>
        String.duplicate("=", 80)

    resumen =
      "\n  • ¿Se cumplió la meta todos los días? #{if todos, do: "Sí", else: "No"}\n" <>
        "  • ¿Se cumplió la meta al menos un día? #{if al_menos_uno, do: "Sí", else: "No"}"

    encabezado <>
      "\n" <>
      Enum.join(lineas, "\n") <>
      resumen
  end

  def r4(liquidaciones) do
    ordenadas =
      Enum.sort_by(liquidaciones, & &1.neto, :desc)

    lineas =
      ordenadas
      |> Enum.with_index(1)
      |> Enum.map(fn {l, idx} ->
        i = String.pad_leading("#{idx}", 2)
        nom = String.pad_trailing(l.nombre, 22)
        k = String.pad_leading("#{numero(l.kilos)} kg", 10)
        pes = String.pad_leading(dinero(l.suma_pesajes), 12)
        bon = String.pad_leading(dinero(l.bonificaciones), 12)
        ali = String.pad_leading(dinero(l.alimentacion), 12)
        net = String.pad_leading(dinero(l.neto), 12)

        "  #{i} | #{nom} | #{k} | #{pes} | #{bon} | #{ali} | #{net}"
      end)

    encabezado =
      "REPORTE 4: LIQUIDACIÓN SEMANAL DE RECOLECTORES\n" <>
        String.duplicate("=", 96)

    hdr =
      "  " <>
        String.pad_leading("#", 2) <>
        " | " <>
        String.pad_trailing("Recolector", 22) <>
        " | " <>
        String.pad_leading("Kilos", 10) <>
        " | " <>
        String.pad_leading("Pesajes", 12) <>
        " | " <>
        String.pad_leading("Bonif.", 12) <>
        " | " <>
        String.pad_leading("Aliment.", 12) <>
        " | " <>
        String.pad_leading("Neto Pagar", 12) <>
        "\n" <>
        String.duplicate("-", 96)

    encabezado <>
      "\n" <>
      hdr <>
      "\n" <>
      Enum.join(lineas, "\n")
  end

  def r5(recolectores, pesajes_validos) do
    rec_map =
      Enum.into(recolectores, %{}, &{&1.codigo, &1.nombre})

    mejores_por_dia =
      Enum.map(1..6, fn dia ->
        pesajes_dia =
          Enum.filter(pesajes_validos, &(&1.dia == dia))

        if pesajes_dia == [] do
          {dia, "Sin pesajes registrados", 0}
        else
          por_rec =
            Enum.group_by(pesajes_dia, & &1.recolector)

          totales =
            Enum.map(por_rec, fn {cod, ps} ->
              {cod, Enum.sum(Enum.map(ps, & &1.kilos))}
            end)

          max_k =
            totales
            |> Enum.map(&elem(&1, 1))
            |> Enum.max()

          empatados =
            totales
            |> Enum.filter(&(elem(&1, 1) == max_k))
            |> Enum.map(&Map.get(rec_map, elem(&1, 0)))

          {dia, Enum.join(empatados, ", "), max_k}
        end
      end)

    lineas_dias =
      Enum.map(mejores_por_dia, fn
        {d, "Sin pesajes registrados", _} ->
          "  Día #{d}: Sin pesajes registrados"

        {d, nombres, k} ->
          "  Día #{d}: #{String.pad_trailing(nombres, 25)} (#{numero(k)} kg)"
      end)

    dias_ganados =
      mejores_por_dia
      |> Enum.reject(&(elem(&1, 1) == "Sin pesajes registrados"))
      |> Enum.flat_map(fn {_, nombres, _} ->
        String.split(nombres, ", ")
      end)
      |> Enum.frequencies()

    max_dias =
      if map_size(dias_ganados) == 0,
        do: 0,
        else: dias_ganados |> Map.values() |> Enum.max()

    mejores_globales =
      dias_ganados
      |> Enum.filter(&(elem(&1, 1) == max_dias))
      |> Enum.map(&elem(&1, 0))

    encabezado =
      "REPORTE 5: MEJOR RECOLECTOR DE CADA DÍA\n" <>
        String.duplicate("=", 80)

    resumen =
      "\n  • Recolector(es) con más días ganados: #{Enum.join(mejores_globales, ", ")} (#{max_dias} día/s)"

    encabezado <>
      "\n" <>
      Enum.join(lineas_dias, "\n") <>
      resumen
  end

  def r6(recolectores, pesajes_validos) do
    rec_map =
      Enum.into(recolectores, %{}, &{&1.codigo, &1.nombre})

    por_rec =
      Enum.group_by(pesajes_validos, & &1.recolector)

    elegibles =
      por_rec
      |> Enum.filter(fn {_, ps} ->
        length(ps) >= 3
      end)
      |> Enum.map(fn {cod, ps} ->
        kilos_totales =
          ps
          |> Enum.map(& &1.kilos)
          |> Enum.sum()

        verdes_ponderado =
          (ps
           |> Enum.map(&(&1.verdes * &1.kilos))
           |> Enum.sum()) / kilos_totales

        {Map.get(rec_map, cod), verdes_ponderado}
      end)

    encabezado =
      "REPORTE 6: MEJOR CALIDAD DE CAFÉ (Mínimo 3 pesajes válidos)\n" <>
        String.duplicate("=", 80)

    cuerpo =
      case elegibles do
        [] ->
          "  No hay recolectores con al menos 3 pesajes válidos para evaluar."

        _ ->
          {nombre, mejor_verdes} =
            Enum.min_by(elegibles, &elem(&1, 1))

          "  • Recolector: #{nombre}\n  • Porcentaje de verdes (ponderado): #{numero(mejor_verdes)}%"
      end

    encabezado <>
      "\n" <>
      cuerpo
  end

  def r7(liquidaciones, pesajes_validos) do
    total_pagar =
      liquidaciones
      |> Enum.map(& &1.neto)
      |> Enum.sum()

    kilos_validos =
      pesajes_validos
      |> Enum.map(& &1.kilos)
      |> Enum.sum()

    costo_promedio =
      if kilos_validos > 0 do
        total_pagar / kilos_validos
      else
        0.0
      end

    encabezado =
      "REPORTE 7: TOTALES GENERALES DE LA SEMANA\n" <>
        String.duplicate("=", 80)

    cuerpo =
      "  • Total a pagar en nómina:  #{dinero(total_pagar)}\n" <>
        "  • Kilos válidos colectados: #{numero(kilos_validos)} kg\n" <>
        "  • Costo promedio por kilo:  #{dinero(costo_promedio)}"

    encabezado <>
      "\n" <>
      cuerpo
  end

  def r8(recolectores, lotes, pesajes_validos) do
    rec_map =
      Enum.into(recolectores, %{}, &{&1.codigo, &1.nombre})

    total_lotes = length(lotes)

    por_rec =
      Enum.group_by(pesajes_validos, & &1.recolector)

    cumplen =
      por_rec
      |> Enum.filter(fn {_, ps} ->
        lotes_trabajados =
          ps
          |> Enum.map(& &1.lote)
          |> Enum.uniq()
          |> length()

        lotes_trabajados == total_lotes
      end)
      |> Enum.map(&Map.get(rec_map, elem(&1, 0)))

    encabezado =
      "REPORTE 8: RECOLECTORES QUE TRABAJARON EN TODOS LOS LOTES\n" <>
        String.duplicate("=", 80)

    cuerpo =
      if cumplen == [] do
        "  Ningún recolector registró trabajo en la totalidad de los lotes."
      else
        Enum.map(cumplen, &"  • #{&1}")
        |> Enum.join("\n")
      end

    encabezado <>
      "\n" <>
      cuerpo
  end

  def ranking(liquidaciones, opciones) do
    campo = Keyword.get(opciones, :campo, :neto)
    orden = Keyword.get(opciones, :orden, :desc)
    limite = Keyword.get(opciones, :limite, length(liquidaciones))

    campo_fn = fn liq ->
      case campo do
        :neto ->
          liq.neto

        :kilos ->
          liq.kilos

        :bruto ->
          liq.suma_pesajes + liq.bonificaciones
      end
    end

    liquidaciones
    |> Enum.sort_by(campo_fn, orden)
    |> Enum.take(limite)
  end

  def combinar_fincas(mapa_finca_propia, finca_vecina) do
    Map.merge(mapa_finca_propia, finca_vecina, fn _dia, kilos_propia, kilos_vecina ->
      kilos_propia + kilos_vecina
    end)
  end

  defp dinero(monto) when is_number(monto) do
    :io_lib.format("$~.2f", [monto * 1.0])
    |> List.to_string()
  end

  defp numero(valor) when is_number(valor) do
    :io_lib.format("~.2f", [valor * 1.0])
    |> List.to_string()
  end
end
