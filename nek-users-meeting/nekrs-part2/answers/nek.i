[Mesh]
  type = NekRSMesh

  # This is the boundary we are coupling via conjugate heat transfer to MOOSE
  boundary = '3'
[]

[Problem]
  type = NekRSProblem
  casename = 'pebble'

  # data passing between nek.i and NekRS internal data structures
  [FieldTransfers]
    [flux]
    # used to write a wall flux into nekrs, automatically creates an AuxVariable named flux 
    # and postprocessor named flux_integral 
      type = NekBoundaryFlux 
      direction = to_nek
      usrwrk_slot = 0
    []
    [temperature]
    # used to get temperature from NekRS and write it into an AuxVariable named temperature
      type = NekFieldVariable 
      direction = from_nek
    []
  []
[]

[Executioner]
  type = Transient

  [TimeStepper]
    type = NekTimeStepper
  []
[]

[UserObjects]
  [layered_bin]
    type = LayeredBin # creates spatial bin for layers in a specified direction
    num_layers = 5
    direction = z
  []
  [wall_temp]
    type = NekBinnedSideAverage # computed the side average of temperature at the pebble boundary 
    bins = 'layered_bin'
    boundary = '3'
    field = temperature
    map_space_by_qp = true # map the NekRS spatial domain to the bin according to the qp
    interval = 10 # every 10 time steps
  []
  [bulk_temp]
    type = NekBinnedVolumeAverage # not evaluated on the NekRSMesh mesh mirror
    bins = 'layered_bin'
    field = temperature
    map_space_by_qp = true
    interval = 10
  []
[]

[VectorPostprocessors]
  [wall]
    type = SpatialUserObjectVectorPostprocessor
    userobject = wall_temp
  []
  [bulk]
    type = SpatialUserObjectVectorPostprocessor
    userobject = bulk_temp
  []
[]

[Outputs]
  exodus = true
  csv = true
  interval = 100
  hide = 'flux_integral'
[]
