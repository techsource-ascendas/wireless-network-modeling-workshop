function intBluetoothLENodes =  addBluetoothInterference(interferenceModeling,maxInterferenceOffset)
% Create a Bluetooth LE Central node as an interferer
source = bluetoothLENode("central","Name","Interferer-1",Position=[1,0,0],TransmitterPower=0, TransmitterGain=0,ReceiverGain=0,ReceiverSensitivity=-100,InterferenceModeling=interferenceModeling,MaxInterferenceOffset=maxInterferenceOffset);
% Create a Bluetooth LE Peripheral node as an interferer
leftSink = bluetoothLENode("Peripheral", Position=[3.2,3,0],Name="interferer-2",TransmitterPower=0, TransmitterGain=0, ReceiverGain=0,ReceiverSensitivity=-100,InterferenceModeling=interferenceModeling,MaxInterferenceOffset=maxInterferenceOffset);
% Create another Bluetooth LE Peripheral node as an interferer
rightSink = bluetoothLENode("Peripheral", Position=[3,3,0],Name="interferer-3",TransmitterPower=0,TransmitterGain=0,ReceiverGain=0, ReceiverSensitivity=-100,InterferenceModeling=interferenceModeling);
% Configure Bluetooth LE multicast audio
cfgCIS = bluetoothLECISConfig(ISOInterval=0.050,NumSubevents=9,BurstNumber=9,SubInterval= 2.5e-3,MaxPDU= 251,FlushTimeout= 1,TMSS= 150e-6,TIFS= 150e-6);
% Configure a Bluetooth LE connection for control packets
cfgConnection = bluetoothLEConnectionConfig(ConnectionInterval=0.1,ActivePeriod=0.001,MaxPDU=27,PHYMode="LE2M");
% Configure a Bluetooth LE connection for control packets
cfgConnection.AccessAddress = "5DA44270"; cfgConnection.ConnectionOffset = 0; [leftConnCfg,leftCISCfg] = configureConnection(cfgConnection,source,leftSink,CISConfig=cfgCIS);
cfgConnection.AccessAddress = "5DA44271"; cfgConnection.ConnectionOffset = 0.05; [rightConnCfg,rightCISCfg] = configureConnection(cfgConnection,source,rightSink,CISConfig=cfgCIS);
% Add Bluetooth audio traffic
leftSinkTraffic = networkTrafficOnOff(DataRate=320,PacketSize=cfgCIS.MaxPDU,GeneratePacket=true,OnTime=Inf,OffTime=0);
rightSinkTraffic = networkTrafficOnOff(DataRate=320,PacketSize=cfgCIS.MaxPDU,GeneratePacket=true,OnTime=Inf,OffTime=0);
addTrafficSource(source,leftSinkTraffic,DestinationNode=leftSink,CISConfig=leftCISCfg);
addTrafficSource(source,rightSinkTraffic,DestinationNode=rightSink,CISConfig=rightCISCfg);
intBluetoothLENodes = [source leftSink rightSink];
end