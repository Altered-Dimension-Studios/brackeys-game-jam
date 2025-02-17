# brackeys-game-jam

# How to use signal_bus

- Add a signal to signal_bus.gd
- Now you can emit new signal from any script

```
SignalBus.plane_entered_interception.emit()
```

- For the script we want to receive the signal, in the _\_ready()_ function connect the signal

```
SignalBus.plane_entered_interception.connect(_on_entered_interception)
```

This allows us to have full control of who emits a signal and who receives it.
