module ReferenceDeployment {

  # ----------------------------------------------------------------------
  # Defaults
  # ----------------------------------------------------------------------

  module Default {
    constant QUEUE_SIZE = 10
    constant STACK_SIZE = 4 * 1024
  }

  # ----------------------------------------------------------------------
  # Active component instances
  # ----------------------------------------------------------------------

  # instance blockDrv: Drv.BlockDriver base id 0x0100 \
  #   queue size Default.QUEUE_SIZE \
  #   stack size Default.STACK_SIZE \
  #   priority 140

  instance rateGroup1: Svc.ActiveRateGroup base id 0x0200 \
    queue size Default.QUEUE_SIZE \
    stack size Default.STACK_SIZE \
    priority 13

  instance rateGroup2: Svc.ActiveRateGroup base id 0x0300 \
    queue size Default.QUEUE_SIZE \
    stack size Default.STACK_SIZE \
    priority 12

  instance rateGroup3: Svc.ActiveRateGroup base id 0x0400 \
    queue size Default.QUEUE_SIZE \
    stack size Default.STACK_SIZE \
    priority 11

  instance cmdDisp: Svc.CommandDispatcher base id 0x0500 \
    queue size 20 \
    stack size Default.STACK_SIZE \
    priority 10

  # instance cmdSeq: Svc.CmdSequencer base id 0x0600 \
  #   queue size Default.QUEUE_SIZE \
  #   stack size Default.STACK_SIZE \
  #   priority 9

  instance comQueue: Svc.ComQueue base id 0x0700 \
      queue size 50 \
      stack size Default.STACK_SIZE \
      priority 8

  # instance fileDownlink: Svc.FileDownlink base id 0x0800 \
  #   queue size 30 \
  #   stack size Default.STACK_SIZE \
  #   priority 8

  # instance fileManager: Svc.FileManager base id 0x0900 \
  #   queue size 30 \
  #   stack size Default.STACK_SIZE \
  #   priority 100

  instance fileUplink: Svc.FileUplink base id 0x0A00 \
    queue size 30 \
    stack size Default.STACK_SIZE \
    priority 7

  instance eventLogger: Svc.ActiveLogger base id 0x0B00 \
    queue size Default.QUEUE_SIZE \
    stack size Default.STACK_SIZE \
    priority 6

  # comment in Svc.TlmChan or Svc.TlmPacketizer
  # depending on which form of telemetry downlink
  # you wish to use

  # instance tlmSend: Svc.TlmChan base id 0x0C00 \
  #   queue size Default.QUEUE_SIZE \
  #   stack size Default.STACK_SIZE \
  #   priority 97

  #instance tlmSend: Svc.TlmPacketizer base id 0x0C00 \
  #    queue size Default.QUEUE_SIZE \
  #    stack size Default.STACK_SIZE \
  #    priority 97

  instance prmDb: Svc.PrmDb base id 0x0D00 \
    queue size Default.QUEUE_SIZE \
    stack size Default.STACK_SIZE \
    priority 5

  instance led: Components.Led base id 0x0E00 \
    queue size Default.QUEUE_SIZE \
    stack size Default.STACK_SIZE \
    priority 4

  # ----------------------------------------------------------------------
  # Queued component instances
  # ----------------------------------------------------------------------

  instance $health: Svc.Health base id 0x2000 \
    queue size 25

  # ----------------------------------------------------------------------
  # Passive component instances
  # ----------------------------------------------------------------------

  @ Communications driver. May be swapped with other com drivers like UART or TCP
  # instance comDriver: Drv.TcpClient base id 0x4000
  instance clockSource: Zephyr.ZephyrRateDriver base id 0x4000

  instance framer: Svc.FprimeFramer base id 0x4100

  # instance fatalAdapter: Svc.AssertFatalAdapter base id 0x4200

  instance fatalHandler: Zephyr.FatalHandler base id 0x4300

  instance bufferManager: Svc.BufferManager base id 0x4400

  instance chronoTime: Svc.ChronoTime base id 0x4500

  instance rateGroupDriver: Svc.RateGroupDriver base id 0x4600

  instance textLogger: Svc.PassiveTextLogger base id 0x4800

  instance deframer: Svc.FprimeDeframer base id 0x4900

  instance systemResources: Svc.SystemResources base id 0x4A00

  instance comStub: Svc.ComStub base id 0x4B00

  instance frameAccumulator: Svc.FrameAccumulator base id 0x4C00

  instance fprimeRouter: Svc.FprimeRouter base id 0x4D00

}



#########################################################################################

# module ReferenceDeployment {

#   # ----------------------------------------------------------------------
#   # Defaults
#   # ----------------------------------------------------------------------

#   module Default {
#     constant QUEUE_SIZE = 10
#     constant STACK_SIZE = 8 * 1024
#   }

#   # ----------------------------------------------------------------------
#   # Active component instances
#   # ----------------------------------------------------------------------

#   instance rateGroup1: Svc.ActiveRateGroup base id 0x0200 \
#     queue size Default.QUEUE_SIZE \
#     stack size Default.STACK_SIZE \
#     priority 13

#   instance rateGroup2: Svc.ActiveRateGroup base id 0x0400 \
#     queue size Default.QUEUE_SIZE \
#     stack size Default.STACK_SIZE \
#     priority 12

#   instance cmdDisp: Svc.CommandDispatcher base id 0x0500 \
#     queue size 20 \
#     stack size Default.STACK_SIZE \
#     priority 11

#   instance comQueue: Svc.ComQueue base id 0x0700 \
#       queue size 50 \
#       stack size Default.STACK_SIZE \
#       priority 10 \

#   instance eventLogger: Svc.ActiveLogger base id 0x0B00 \
#     queue size Default.QUEUE_SIZE \
#     stack size Default.STACK_SIZE \
#     priority 9

#   # comment in Svc.TlmChan or Svc.TlmPacketizer
#   # depending on which form of telemetry downlink
#   # you wish to use

#   #instance tlmSend: Svc.TlmChan base id 0x0C00 \
#   #  queue size Default.QUEUE_SIZE \
#   #  stack size Default.STACK_SIZE \
#   #  priority 97

#   #instance tlmSend: Svc.TlmPacketizer base id 0x0C00 \
#   #    queue size Default.QUEUE_SIZE \
#   #    stack size Default.STACK_SIZE \
#   #    priority 97

#   # ----------------------------------------------------------------------
#   # Queued component instances
#   # ----------------------------------------------------------------------

#   instance $health: Svc.Health base id 0x2000 \
#     queue size 25

#   # ----------------------------------------------------------------------
#   # Passive component instances
#   # ----------------------------------------------------------------------

#   instance clockSource: Zephyr.ZephyrRateDriver base id 0x4000


#   instance framer: Svc.FprimeFramer base id 0x4100

#   #instance fatalAdapter: Svc.AssertFatalAdapter base id 0x4200

#   instance fatalHandler: Zephyr.FatalHandler base id 0x4300

#   instance bufferManager: Svc.BufferManager base id 0x4400

#   instance chronoTime: Svc.ChronoTime base id 0x4500

#   instance rateGroupDriver: Svc.RateGroupDriver base id 0x4600

#   instance textLogger: Svc.PassiveTextLogger base id 0x4800

#   instance deframer: Svc.FprimeDeframer base id 0x4900

#   # instance systemResources: Svc.SystemResources base id 0x4A00

#   instance comStub: Svc.ComStub base id 0x4B00

#   instance frameAccumulator: Svc.FrameAccumulator base id 0x4C00

#   instance fprimeRouter: Svc.FprimeRouter base id 0x4D00

#   # instance version: Svc.Version base id 0x4E00
# }
