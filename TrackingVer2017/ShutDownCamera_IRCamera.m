function ShutDownCamera_IRCamera(vid)
vid.StopGrabbing;
vid.Disconnect();
vid.Dispose();
delete vid
end