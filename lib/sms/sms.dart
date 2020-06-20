class SmsCommands {
  const SmsCommands();

  static const requestLocationLog = "A@GETPL";
  static const requestMostRecentLocation = "A@S,1";
  static const switchContinuousTrackingOn = "A@COP,1,720,300";
  static const switchContinuousTrackingOff = "A@COP,2,,";
  static const triggerAlarm = "BEEP,3";
}
