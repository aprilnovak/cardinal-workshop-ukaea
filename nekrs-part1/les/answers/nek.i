[Mesh]
  type = NekRSMesh
  order = FIRST
  volume = true
[]

[Problem]
  type = NekRSStandaloneProblem
  casename = 'pebble'
[]

[Executioner]
  type = Transient

  [TimeStepper]
    type = NekTimeStepper
  []
[]
