module ReferenceDeployment {

  # ----------------------------------------------------------------------
  # Symbolic constants for port numbers
  # ----------------------------------------------------------------------

  enum Ports_RateGroups {
    rateGroup1
    rateGroup2
    rateGroup3
  }
  enum Ports_ComPacketQueue {
    EVENTS,
    TELEMETRY
  }
  # enum Ports_ComBufferQueue {
  #   FILE_DOWNLINK
  # }

  topology ReferenceDeployment {

    # ----------------------------------------------------------------------
    # Instances used in the topology
    # ----------------------------------------------------------------------

    instance $health
    # instance blockDrv
    instance clockSource
    # instance tlmSend
    instance cmdDisp
    # instance cmdSeq #
    instance comDriver
    instance comQueue
    instance comStub
    instance fprimeRouter
    instance deframer
    instance frameAccumulator
    instance eventLogger
    # instance fatalAdapter #
    instance fatalHandler
    # instance fileDownlink #
    # instance fileManager #
    instance fileUplink #
    instance bufferManager
    instance framer
    instance chronoTime
    instance prmDb #
    instance rateGroup1
    instance rateGroup2
    instance rateGroup3 #
    instance rateGroupDriver
    instance textLogger
    instance systemResources #
    instance led
    instance gpioDriver

    # ----------------------------------------------------------------------
    # Pattern graph specifiers
    # ----------------------------------------------------------------------

    command connections instance cmdDisp

    event connections instance eventLogger

    param connections instance prmDb

    # telemetry connections instance tlmSend

    text event connections instance textLogger

    time connections instance chronoTime

  
    health connections instance $health #

    # ----------------------------------------------------------------------
    # Direct graph specifiers
    # ----------------------------------------------------------------------

    connections Downlink {
      # Inputs to ComQueue (events, telemetry, file)
      eventLogger.PktSend         -> comQueue.comPacketQueueIn[Ports_ComPacketQueue.EVENTS]
      # tlmSend.PktSend             -> comQueue.comPacketQueueIn[Ports_ComPacketQueue.TELEMETRY]
      #
      # fileDownlink.bufferSendOut  -> comQueue.bufferQueueIn[Ports_ComBufferQueue.FILE_DOWNLINK]
      #
      # comQueue.bufferReturnOut[Ports_ComBufferQueue.FILE_DOWNLINK] -> fileDownlink.bufferReturn

      # ComQueue <-> Framer
      comQueue.dataOut   -> framer.dataIn
      framer.dataReturnOut -> comQueue.dataReturnIn
      framer.comStatusOut  -> comQueue.comStatusIn

      # Buffer Management for Framer
      framer.bufferAllocate   -> bufferManager.bufferGetCallee
      framer.bufferDeallocate -> bufferManager.bufferSendIn

      # Framer <-> ComStub
      framer.dataOut        -> comStub.dataIn
      comStub.dataReturnOut -> framer.dataReturnIn
      comStub.comStatusOut  -> framer.comStatusIn

      # ComStub <-> ComDriver
      comStub.drvSendOut      -> comDriver.$send
      comDriver.sendReturnOut -> comStub.drvSendReturnIn
      comDriver.ready         -> comStub.drvConnected
    }

    connections FaultProtection {
      eventLogger.FatalAnnounce -> fatalHandler.FatalReceive
    }

    connections RateGroups {
      # Block driver
      # blockDrv.CycleOut -> rateGroupDriver.CycleIn
      clockSource.CycleOut -> rateGroupDriver.CycleIn

      # Rate group 1
      rateGroupDriver.CycleOut[Ports_RateGroups.rateGroup1] -> rateGroup1.CycleIn
      # rateGroup1.RateGroupMemberOut[0] -> tlmSend.Run
      #
      # rateGroup1.RateGroupMemberOut[1] -> fileDownlink.Run
      #
      rateGroup1.RateGroupMemberOut[2] -> systemResources.run
      #
      rateGroup1.RateGroupMemberOut[3] -> comQueue.run
      rateGroup1.RateGroupMemberOut[0] -> comDriver.schedIn

      # Rate group 2
      rateGroupDriver.CycleOut[Ports_RateGroups.rateGroup2] -> rateGroup2.CycleIn
      #
      # rateGroup2.RateGroupMemberOut[0] -> cmdSeq.schedIn

      # Rate group 3
      rateGroupDriver.CycleOut[Ports_RateGroups.rateGroup3] -> rateGroup3.CycleIn
      #
      rateGroup3.RateGroupMemberOut[0] -> $health.Run
      # rateGroup3.RateGroupMemberOut[1] -> blockDrv.Sched
      #
      rateGroup3.RateGroupMemberOut[2] -> bufferManager.schedIn
    }

    #
    # connections Sequencer {
    #   cmdSeq.comCmdOut -> cmdDisp.seqCmdBuff
    #   cmdDisp.seqCmdStatus -> cmdSeq.cmdResponseIn
    # }
    #

    connections Uplink {
      # ComDriver buffer allocations
      comDriver.allocate      -> bufferManager.bufferGetCallee
      comDriver.deallocate    -> bufferManager.bufferSendIn
      # ComDriver <-> ComStub
      comDriver.$recv             -> comStub.drvReceiveIn
      comStub.drvReceiveReturnOut -> comDriver.recvReturnIn
      # ComStub <-> FrameAccumulator
      comStub.dataOut                -> frameAccumulator.dataIn
      frameAccumulator.dataReturnOut -> comStub.dataReturnIn
      # FrameAccumulator buffer allocations
      frameAccumulator.bufferDeallocate -> bufferManager.bufferSendIn
      frameAccumulator.bufferAllocate   -> bufferManager.bufferGetCallee
      # FrameAccumulator <-> Deframer
      frameAccumulator.dataOut  -> deframer.dataIn
      deframer.dataReturnOut    -> frameAccumulator.dataReturnIn
      # Deframer <-> Router
      deframer.dataOut           -> fprimeRouter.dataIn
      fprimeRouter.dataReturnOut -> deframer.dataReturnIn
      # Router buffer allocations
      fprimeRouter.bufferAllocate   -> bufferManager.bufferGetCallee
      fprimeRouter.bufferDeallocate -> bufferManager.bufferSendIn
      # Router <-> CmdDispatcher/FileUplink
      fprimeRouter.commandOut  -> cmdDisp.seqCmdBuff
      cmdDisp.seqCmdStatus     -> fprimeRouter.cmdResponseIn
      #
      fprimeRouter.fileOut     -> fileUplink.bufferSendIn
      #
      fileUplink.bufferSendOut -> fprimeRouter.fileBufferReturnIn
    }

    connections ReferenceDeployment {
      # Add here connections to user-defined components
    }

    connections LedConnections {
      # Rate Group 1 (1Hz cycle) ouput is connected to led's run input
      rateGroup1.RateGroupMemberOut[1] -> led.run
      # led's gpioSet output is connected to gpioDriver's gpioWrite input
      led.gpioSet -> gpioDriver.gpioWrite
    }

  }

}


# module ReferenceDeployment {

#   # ----------------------------------------------------------------------
#   # Symbolic constants for port numbers
#   # ----------------------------------------------------------------------

#   enum Ports_RateGroups {
#     rateGroup1
#     rateGroup2
#     rateGroup3
#   }
#   enum Ports_ComPacketQueue {
#     EVENTS,
#     TELEMETRY
#   }


#   topology ReferenceDeployment {

#     # ----------------------------------------------------------------------
#     # Instances used in the topology
#     # ----------------------------------------------------------------------

#     # instance $health
#     instance clockSource
#     # instance tlmSend
#     instance cmdDisp
#     instance comDriver
#     instance comQueue
#     instance comStub
#     instance fprimeRouter
#     instance deframer
#     instance frameAccumulator
#     instance eventLogger
#     #instance fatalAdapter
#     instance fatalHandler
#     instance bufferManager
#     instance framer
#     instance chronoTime
#     instance rateGroup1
#     instance rateGroup2
#     instance rateGroupDriver
#     instance textLogger
#     # instance systemResources
#     # instance version

#     # ----------------------------------------------------------------------
#     # Pattern graph specifiers
#     # ----------------------------------------------------------------------

#     command connections instance cmdDisp

#     event connections instance eventLogger

#     # telemetry connections instance tlmSend

#     text event connections instance textLogger

#     time connections instance chronoTime

#     # health connections instance $health

#     # ----------------------------------------------------------------------
#     # Telemetry packets
#     # ----------------------------------------------------------------------

#     # include "ReferenceDeploymentPackets.fppi"


#     # ----------------------------------------------------------------------
#     # Direct graph specifiers
#     # ----------------------------------------------------------------------

#     connections Downlink {
#       # Inputs to ComQueue (events, telemetry)
#       eventLogger.PktSend         -> comQueue.comPacketQueueIn[Ports_ComPacketQueue.EVENTS]
#       # tlmSend.PktSend             -> comQueue.comPacketQueueIn[Ports_ComPacketQueue.TELEMETRY]

#       # ComQueue <-> Framer
#       comQueue.dataOut   -> framer.dataIn
#       framer.dataReturnOut -> comQueue.dataReturnIn
#       framer.comStatusOut  -> comQueue.comStatusIn

#       # Buffer Management for Framer
#       framer.bufferAllocate   -> bufferManager.bufferGetCallee
#       framer.bufferDeallocate -> bufferManager.bufferSendIn

#       # Framer <-> ComStub
#       framer.dataOut        -> comStub.dataIn
#       comStub.dataReturnOut -> framer.dataReturnIn
#       comStub.comStatusOut  -> framer.comStatusIn

#       # ComStub <-> ComDriver
#       comStub.drvSendOut      -> comDriver.$send
#       comDriver.sendReturnOut -> comStub.drvSendReturnIn
#       comDriver.ready         -> comStub.drvConnected
#     }

#     connections FaultProtection {
#       eventLogger.FatalAnnounce -> fatalHandler.FatalReceive
#     }

#     connections RateGroups {
#       # Block driver
#       clockSource.CycleOut -> rateGroupDriver.CycleIn

#       # Rate group 1
#       rateGroupDriver.CycleOut[Ports_RateGroups.rateGroup1] -> rateGroup1.CycleIn
#       rateGroup1.RateGroupMemberOut[0] -> comDriver.schedIn
#       # rateGroup1.RateGroupMemberOut[2] -> tlmSend.Run

#       # Rate group 2
#       rateGroupDriver.CycleOut[Ports_RateGroups.rateGroup2] -> rateGroup2.CycleIn
#       # rateGroup2.RateGroupMemberOut[0] -> $health.Run
# #      rateGroup2.RateGroupMemberOut[1] -> blockDrv.Sched
# #      rateGroup2.RateGroupMemberOut[2] -> bufferManager.schedIn
# #      rateGroup2.RateGroupMemberOut[3] -> systemResources.run
# #      rateGroup1.RateGroupMemberOut[0] -> comQueue.run
#     }

#     connections Uplink {
#       # ComDriver buffer allocations
#       comDriver.allocate      -> bufferManager.bufferGetCallee
#       comDriver.deallocate    -> bufferManager.bufferSendIn
#       # ComDriver <-> ComStub
#       comDriver.$recv             -> comStub.drvReceiveIn
#       comStub.drvReceiveReturnOut -> comDriver.recvReturnIn
#       # ComStub <-> FrameAccumulator
#       comStub.dataOut                -> frameAccumulator.dataIn
#       frameAccumulator.dataReturnOut -> comStub.dataReturnIn
#       # FrameAccumulator buffer allocations
#       frameAccumulator.bufferDeallocate -> bufferManager.bufferSendIn
#       frameAccumulator.bufferAllocate   -> bufferManager.bufferGetCallee
#       # FrameAccumulator <-> Deframer
#       frameAccumulator.dataOut  -> deframer.dataIn
#       deframer.dataReturnOut    -> frameAccumulator.dataReturnIn
#       # Deframer <-> Router
#       deframer.dataOut           -> fprimeRouter.dataIn
#       fprimeRouter.dataReturnOut -> deframer.dataReturnIn
#       # Router buffer allocations
#       fprimeRouter.bufferAllocate   -> bufferManager.bufferGetCallee
#       fprimeRouter.bufferDeallocate -> bufferManager.bufferSendIn
#       # Router <-> CmdDispatcher
#       fprimeRouter.commandOut  -> cmdDisp.seqCmdBuff
#       cmdDisp.seqCmdStatus     -> fprimeRouter.cmdResponseIn
#     }

#     connections ReferenceDeployment {
#       # Add here connections to user-defined components
#     }

#   }

# }
