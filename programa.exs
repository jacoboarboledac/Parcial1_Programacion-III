defmodule Programa do
  def main do
    recolectores = Datos.recolectores()
    lotes = Datos.lotes()
    pesajes_raw = Datos.pesajes()

    rec_map =
      Enum.into(recolectores, %{}, &{&1.codigo, &1})

    lotes_map =
      Enum.into(lotes, %{}, &{&1.id, &1})

    {validos, rechazados} =
      procesar_pesajes(pesajes_raw, rec_map, lotes_map)

    entrada =
      Util.leer(
        "\nIngrese un pesaje adicional (recolector;lote;dia;kilos;verdes) o Enter para omitir: ",
        :string
      )

    {validos_finales, rechazados_finales} =
      manejar_pesaje_adicional(
        entrada,
        validos,
        rechazados,
        rec_map,
        lotes_map
      )

    liquidaciones =
      Enum.map(
        recolectores,
        &Liquidacion.liquidar_recolector(&1, validos_finales)
      )

    imprimir_reportes(
      rechazados_finales,
      lotes,
      validos_finales,
      liquidaciones,
      recolectores
    )

    imprimir_rankings(liquidaciones)
    imprimir_combinacion_fincas(validos_finales)

    codigo_consulta =
      Util.leer(
        "\nIngrese el código del recolector para ver su desprendible: ",
        :string
      )

    imprimir_desprendible(
      codigo_consulta,
      liquidaciones,
      rec_map
    )
  end

  defp procesar_pesajes(pesajes, rec_map, lotes_map) do
    Enum.reduce(
      pesajes,
      {[], []},
      fn p, {val, rech} ->
        case Validacion.validar_pesaje(p, rec_map, lotes_map) do
          {:ok, pesaje} ->
            {[pesaje | val], rech}

          {:error, motivo} ->
            {val, [{p, motivo} | rech]}
        end
      end
    )
    |> then(fn {v, r} ->
      {Enum.reverse(v), Enum.reverse(r)}
    end)
  end

  defp manejar_pesaje_adicional(
         "",
         validos,
         rechazados,
         _,
         _
       ) do
    {validos, rechazados}
  end

  defp manejar_pesaje_adicional(
         entrada,
         validos,
         rechazados,
         rec_map,
         lotes_map
       ) do
    partes =
      String.split(entrada, ";")
      |> Enum.map(&String.trim/1)

    case parsear_pesaje_adicional(partes) do
      {:ok, p} ->
        case Validacion.validar_pesaje(
               p,
               rec_map,
               lotes_map
             ) do
          {:ok, pesaje_valido} ->
            IO.puts(
              "\n[+] Pesaje agregado exitosamente: #{p.recolector} en #{p.lote}, día #{p.dia}, #{p.kilos} kg, #{p.verdes}% verdes."
            )

            {[pesaje_valido | validos], rechazados}

          {:error, motivo} ->
            IO.puts(
              "\n[-] Pesaje rechazado: #{motivo}"
            )

            {validos, [{p, motivo} | rechazados]}
        end

      {:error, :formato_invalido} ->
        IO.puts(
          "\n[-] Pesaje rechazado: formato_invalido"
        )

        {validos, rechazados}
    end
  end

  defp parsear_pesaje_adicional([
         rec,
         lote,
         dia_str,
         kilos_str,
         verdes_str
       ]) do
    with {dia, ""} <- Integer.parse(dia_str),
         {kilos, ""} <- parse_num(kilos_str),
         {verdes, ""} <- parse_num(verdes_str) do
      {:ok,
       %{
         recolector: rec,
         lote: lote,
         dia: dia,
         kilos: kilos,
         verdes: verdes
       }}
    else
      _ ->
        {:error, :formato_invalido}
    end
  end

  defp parsear_pesaje_adicional(_) do
    {:error, :formato_invalido}
  end

  defp parse_num(str) do
    case Float.parse(str) do
      {num, ""} ->
        {num, ""}

      :error ->
        Integer.parse(str)

      _ ->
        :error
    end
  end

  defp imprimir_reportes(
         rechazados,
         lotes,
         validos,
         liquidaciones,
         recolectores
       ) do
    IO.puts(
      "\n" <> String.duplicate("=", 96)
    )

    IO.puts(Reportes.r1(rechazados))

    IO.puts(
      "\n" <> String.duplicate("=", 96)
    )

    IO.puts(Reportes.r2(lotes, validos))

    IO.puts(
      "\n" <> String.duplicate("=", 96)
    )

    IO.puts(Reportes.r3(validos))

    IO.puts(
      "\n" <> String.duplicate("=", 96)
    )

    IO.puts(Reportes.r4(liquidaciones))

    IO.puts(
      "\n" <> String.duplicate("=", 96)
    )

    IO.puts(Reportes.r5(recolectores, validos))

    IO.puts(
      "\n" <> String.duplicate("=", 96)
    )

    IO.puts(Reportes.r6(recolectores, validos))

    IO.puts(
      "\n" <> String.duplicate("=", 96)
    )

    IO.puts(Reportes.r7(liquidaciones, validos))

    IO.puts(
      "\n" <> String.duplicate("=", 96)
    )

    IO.puts(
      Reportes.r8(
        recolectores,
        lotes,
        validos
      )
    )

    IO.puts(
      String.duplicate("=", 96)
    )
  end

  defp imprimir_rankings(liquidaciones) do
    IO.puts(
      "\n" <> String.duplicate("=", 96)
    )

    IO.puts(
      "DEMOSTRACIÓN DE RANKINGS (KEYWORD LISTS)"
    )

    IO.puts(
      String.duplicate("-", 96)
    )

    IO.puts(
      "\n [1] Ranking por defecto (Neto descendente):"
    )

    mostrar_lista_ranking(
      Reportes.ranking(liquidaciones, [])
    )

    IO.puts(
      "\n [2] Ranking Top 3 por Kilos recolectados:"
    )

    mostrar_lista_ranking(
      Reportes.ranking(
        liquidaciones,
        campo: :kilos,
        limite: 3
      )
    )

    IO.puts(
      "\n [3] Ranking por valor Bruto ascendente:"
    )

    mostrar_lista_ranking(
      Reportes.ranking(
        liquidaciones,
        orden: :asc,
        campo: :bruto
      )
    )
  end

  defp mostrar_lista_ranking(lista) do
    Enum.each(lista, fn l ->
      nom =
        String.pad_trailing(
          l.nombre,
          22
        )

      k =
        String.pad_leading(
          "#{numero(l.kilos)} kg",
          10
        )

      net =
        String.pad_leading(
          dinero(l.neto),
          12
        )

      IO.puts(
        " • #{nom} | #{k} | Neto: #{net}"
      )
    end)
  end

defp imprimir_combinacion_fincas(validos_finales) do
  kilos_por_dia_propia =
    Enum.group_by(validos_finales, & &1.dia)
    |> Enum.map(fn {dia, pesajes} ->
      {dia, Enum.sum(Enum.map(pesajes, & &1.kilos))}
    end)
    |> Enum.into(%{})

  finca_vecina = %{
    1 => 520.5,
    2 => 610,
    3 => 480,
    5 => 700,
    7 => 300
  }

  produccion_combinada =
    Reportes.combinar_fincas(kilos_por_dia_propia, finca_vecina)

  IO.puts("\n" <> String.duplicate("=", 96))
  IO.puts("PRODUCCIÓN COMBINADA CON FINCA VECINA (C.2)")
  IO.puts(String.duplicate("-", 96))
  IO.inspect(produccion_combinada)
end

  defp imprimir_desprendible(
         codigo,
         liquidaciones,
         rec_map
       ) do
    case Enum.find(
           liquidaciones,
           &(&1.codigo == codigo)
         ) do
      nil ->
        IO.puts(
          "\n[-] No existe un recolector registrado con el código '#{codigo}'."
        )

      liq ->
        nombre =
          Map.get(rec_map, codigo).nombre

        IO.puts(
          "\n" <> String.duplicate("=", 80)
        )

        IO.puts(
          "DESPRENDIBLE DE PAGO SEMANAL"
        )

        IO.puts(
          String.duplicate("-", 80)
        )

        IO.puts(
          " Recolector: #{nombre} (#{codigo})"
        )

        IO.puts(
          String.duplicate("-", 80)
        )

        Enum.each(1..6, fn dia ->
          case Map.get(
                 liq.pesajes_por_dia,
                 dia
               ) do
            nil ->
              :ok

            pesajes ->
              kilos =
                Enum.map(
                  pesajes,
                  & &1.kilos
                )
                |> Enum.sum()

              val =
                Enum.map(
                  pesajes,
                  &Liquidacion.calcular_valor_pesaje/1
                )
                |> Enum.sum()

              bonif =
                if kilos >= 120 do
                  8000.0
                else
                  0.0
                end

              d_str =
                "Día #{dia}"
                |> String.pad_trailing(6)

              k_str =
                String.pad_leading(
                  "#{numero(kilos)} kg",
                  9
                )

              v_str =
                String.pad_leading(
                  dinero(val),
                  11
                )

              b_str =
                String.pad_leading(
                  dinero(bonif),
                  11
                )

              IO.puts(
                " #{d_str} | Kilos: #{k_str} | Pesajes: #{v_str} | Bonificación: #{b_str}"
              )
          end
        end)

        IO.puts(
          String.duplicate("-", 80)
        )

        IO.puts(
          " • Suma valor pesajes : #{dinero(liq.suma_pesajes)}"
        )

        IO.puts(
          " • Bonificaciones : #{dinero(liq.bonificaciones)}"
        )

        IO.puts(
          " • Descuento alimento : -#{dinero(liq.alimentacion)} (#{liq.dias_trabajados} días)"
        )

        IO.puts(
          String.duplicate("-", 80)
        )

        IO.puts(
          " NETO A PAGAR : #{dinero(liq.neto)}"
        )

        IO.puts(
          String.duplicate("=", 80)
        )
    end
  end

  defp dinero(monto) when is_number(monto) do
    :io_lib.format(
      "$~.2f",
      [monto * 1.0]
    )
    |> List.to_string()
  end

  defp numero(valor) when is_number(valor) do
    :io_lib.format(
      "~.2f",
      [valor * 1.0]
    )
    |> List.to_string()
  end
end

Programa.main()
