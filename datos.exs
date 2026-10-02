defmodule Datos do

  def recolectores do
    [
      %{codigo: "R01", nombre: "Luz Marina Ospina", alimentacion: true},
      %{codigo: "R02", nombre: "Jhon Fredy Castaño", alimentacion: false},
      %{codigo: "R03", nombre: "Dora Cardona", alimentacion: true},
      %{codigo: "R04", nombre: "Wilson Arango", alimentacion: false},
      %{codigo: "R05", nombre: "Carlos Alberto López", alimentacion: true},
      %{codigo: "R06", nombre: "Martha Elena Gómez", alimentacion: false},
      %{codigo: "R07", nombre: "Andrés Felipe Ruiz", alimentacion: true},
      %{codigo: "R08", nombre: "Sandra Milena Pérez", alimentacion: false},
      %{codigo: "R09", nombre: "Juan David Torres", alimentacion: true},
      %{codigo: "R10", nombre: "Ana María Restrepo", alimentacion: false}
    ]
  end

  def lotes do
    [
      %{id: "L1", nombre: "El Mirador", hectareas: 2.5},
      %{id: "L2", nombre: "La Cañada", hectareas: 1.5},
      %{id: "L3", nombre: "Buenavista", hectareas: 3.0},
      %{id: "L4", nombre: "El Paraíso", hectareas: 4.0}
    ]
  end

  def pesajes do
    [

      # R01
      %{recolector: "R01", lote: "L1", dia: 1, kilos: 70, verdes: 1.5},
      %{recolector: "R01", lote: "L2", dia: 1, kilos: 55, verdes: 6},
      %{recolector: "R01", lote: "L1", dia: 2, kilos: 90, verdes: 12},
      %{recolector: "R01", lote: "L3", dia: 3, kilos: 80, verdes: 4},
      %{recolector: "R01", lote: "L4", dia: 4, kilos: 100, verdes: 5},
      %{recolector: "R01", lote: "L2", dia: 5, kilos: 65, verdes: 3},
      %{recolector: "R01", lote: "L3", dia: 6, kilos: 75, verdes: 2},
      %{recolector: "R01", lote: "L4", dia: 2, kilos: 85, verdes: 7},

      # R02
      %{recolector: "R02", lote: "L1", dia: 1, kilos: 100, verdes: 2},
      %{recolector: "R02", lote: "L3", dia: 1, kilos: 45, verdes: 3},
      %{recolector: "R02", lote: "L2", dia: 2, kilos: 60.5, verdes: 4},
      %{recolector: "R02", lote: "L3", dia: 3, kilos: 65, verdes: 5},
      %{recolector: "R02", lote: "L3", dia: 4, kilos: 110, verdes: 1},
      %{recolector: "R02", lote: "L4", dia: 5, kilos: 95, verdes: 8},
      %{recolector: "R02", lote: "L1", dia: 6, kilos: 72, verdes: 6},
      %{recolector: "R02", lote: "L2", dia: 3, kilos: 88, verdes: 9},

      # R03
      %{recolector: "R03", lote: "L2", dia: 1, kilos: 80, verdes: 3},
      %{recolector: "R03", lote: "L3", dia: 1, kilos: 60, verdes: 4},
      %{recolector: "R03", lote: "L1", dia: 2, kilos: 85, verdes: 2.5},
      %{recolector: "R03", lote: "L2", dia: 3, kilos: 95, verdes: 8},
      %{recolector: "R03", lote: "L1", dia: 3, kilos: 40, verdes: 0},
      %{recolector: "R03", lote: "L4", dia: 4, kilos: 105, verdes: 6},
      %{recolector: "R03", lote: "L3", dia: 5, kilos: 78, verdes: 5},
      %{recolector: "R03", lote: "L4", dia: 6, kilos: 92, verdes: 7},

      # R04
      %{recolector: "R04", lote: "L3", dia: 1, kilos: 75, verdes: 3},
      %{recolector: "R04", lote: "L4", dia: 2, kilos: 90, verdes: 5},
      %{recolector: "R04", lote: "L1", dia: 3, kilos: 65, verdes: 4},
      %{recolector: "R04", lote: "L2", dia: 4, kilos: 82, verdes: 6},
      %{recolector: "R04", lote: "L3", dia: 5, kilos: 70, verdes: 2},
      %{recolector: "R04", lote: "L4", dia: 6, kilos: 98, verdes: 8},
      %{recolector: "R04", lote: "L1", dia: 2, kilos: 55, verdes: 1},
      %{recolector: "R04", lote: "L2", dia: 5, kilos: 73, verdes: 4},

      # R05
      %{recolector: "R05", lote: "L1", dia: 1, kilos: 85, verdes: 4},
      %{recolector: "R05", lote: "L2", dia: 2, kilos: 92, verdes: 6},
      %{recolector: "R05", lote: "L3", dia: 3, kilos: 105, verdes: 3},
      %{recolector: "R05", lote: "L4", dia: 4, kilos: 115, verdes: 7},
      %{recolector: "R05", lote: "L1", dia: 5, kilos: 68, verdes: 5},
      %{recolector: "R05", lote: "L2", dia: 6, kilos: 77, verdes: 2},
      %{recolector: "R05", lote: "L3", dia: 2, kilos: 89, verdes: 8},
      %{recolector: "R05", lote: "L4", dia: 5, kilos: 96, verdes: 4},

      # R06
      %{recolector: "R06", lote: "L2", dia: 1, kilos: 62, verdes: 5},
      %{recolector: "R06", lote: "L3", dia: 2, kilos: 74, verdes: 3},
      %{recolector: "R06", lote: "L4", dia: 3, kilos: 86, verdes: 6},
      %{recolector: "R06", lote: "L1", dia: 4, kilos: 91, verdes: 4},
      %{recolector: "R06", lote: "L2", dia: 5, kilos: 69, verdes: 2},
      %{recolector: "R06", lote: "L3", dia: 6, kilos: 79, verdes: 7},
      %{recolector: "R06", lote: "L4", dia: 1, kilos: 88, verdes: 5},
      %{recolector: "R06", lote: "L1", dia: 3, kilos: 97, verdes: 3},

      # R07
      %{recolector: "R07", lote: "L3", dia: 1, kilos: 93, verdes: 4},
      %{recolector: "R07", lote: "L4", dia: 2, kilos: 108, verdes: 6},
      %{recolector: "R07", lote: "L1", dia: 3, kilos: 82, verdes: 2},
      %{recolector: "R07", lote: "L2", dia: 4, kilos: 76, verdes: 5},
      %{recolector: "R07", lote: "L3", dia: 5, kilos: 99, verdes: 8},
      %{recolector: "R07", lote: "L4", dia: 6, kilos: 87, verdes: 3},
      %{recolector: "R07", lote: "L1", dia: 2, kilos: 71, verdes: 4},
      %{recolector: "R07", lote: "L2", dia: 5, kilos: 94, verdes: 7},

      # R08
      %{recolector: "R08", lote: "L4", dia: 1, kilos: 80, verdes: 3},
      %{recolector: "R08", lote: "L1", dia: 2, kilos: 72, verdes: 5},
      %{recolector: "R08", lote: "L2", dia: 3, kilos: 84, verdes: 6},
      %{recolector: "R08", lote: "L3", dia: 4, kilos: 91, verdes: 4},
      %{recolector: "R08", lote: "L4", dia: 5, kilos: 103, verdes: 7},
      %{recolector: "R08", lote: "L1", dia: 6, kilos: 67, verdes: 2},
      %{recolector: "R08", lote: "L2", dia: 4, kilos: 78, verdes: 8},
      %{recolector: "R08", lote: "L3", dia: 6, kilos: 89, verdes: 5},

      # R09
      %{recolector: "R09", lote: "L1", dia: 1, kilos: 80, verdes: 3},
      %{recolector: "R09", lote: "L2", dia: 2, kilos: 95, verdes: 6},
      %{recolector: "R09", lote: "L3", dia: 3, kilos: 88, verdes: 4},
      %{recolector: "R09", lote: "L4", dia: 4, kilos: 102, verdes: 7},
      %{recolector: "R09", lote: "L1", dia: 5, kilos: 73, verdes: 2},
      %{recolector: "R09", lote: "L2", dia: 6, kilos: 81, verdes: 5},
      %{recolector: "R09", lote: "L3", dia: 2, kilos: 90, verdes: 3},
      %{recolector: "R09", lote: "L4", dia: 5, kilos: 97, verdes: 8},

      # R10
      %{recolector: "R10", lote: "L2", dia: 1, kilos: 76, verdes: 4},
      %{recolector: "R10", lote: "L3", dia: 2, kilos: 83, verdes: 6},
      %{recolector: "R10", lote: "L4", dia: 3, kilos: 101, verdes: 5},
      %{recolector: "R10", lote: "L1", dia: 4, kilos: 69, verdes: 3},
      %{recolector: "R10", lote: "L2", dia: 5, kilos: 87, verdes: 7},
      %{recolector: "R10", lote: "L3", dia: 6, kilos: 93, verdes: 2},
      %{recolector: "R10", lote: "L4", dia: 1, kilos: 110, verdes: 6},
      %{recolector: "R10", lote: "L1", dia: 3, kilos: 79, verdes: 4},

      # ==========================================================
      # PESAJES INVÁLIDOS
      # ==========================================================

      # Recolector desconocido
      %{recolector: "R99", lote: "L1", dia: 1, kilos: 70, verdes: 3},
      %{recolector: "R100", lote: "L2", dia: 2, kilos: 80, verdes: 4},

      # Lote desconocido
      %{recolector: "R01", lote: "L99", dia: 1, kilos: 70, verdes: 3},
      %{recolector: "R02", lote: "L50", dia: 2, kilos: 80, verdes: 4},

      # Día inválido
      %{recolector: "R85", lote: "L1", dia: 0, kilos: 70, verdes: 3},
      %{recolector: "R04", lote: "L2", dia: 7, kilos: 80, verdes: 4},

      # Kilos fuera de rango
      %{recolector: "R05", lote: "L3", dia: 2, kilos: 0, verdes: 3},
      %{recolector: "R06", lote: "L4", dia: 3, kilos: 501, verdes: 4},

      # Porcentaje inválido
      %{recolector: "R07", lote: "L1", dia: 4, kilos: 80, verdes: -2},
      %{recolector: "R08", lote: "L2", dia: 5, kilos: 90, verdes: 101}
    ]

  end

end
