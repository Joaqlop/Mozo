import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mozo_app/models/models.dart';
import 'package:mozo_app/providers/providers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class PrintScreen extends StatefulWidget {
  const PrintScreen({super.key});

  @override
  State<PrintScreen> createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  bool connected = false;
  BluetoothDevice? device;
  String stateMessage = '';

  @override
  void initState() {
    super.initState();

    bluetoothPrint.state.listen((value) {
      if (value == 12 && connected) {
        Provider.of<PrinterProvider>(context).printing;
        _startPrint(
          bluetoothPrint,
          Provider.of<SelectedProductProvider>(context).selectedProducts,
          Provider.of<SelectedProductProvider>(context).qtySelected,
          Provider.of<SelectedProductProvider>(context).total,
        );
        setState(() async {
          stateMessage = 'Ticket impreso correctamente.';
          Provider.of<PrinterProvider>(context).endPrinting();
        });
      } else {
        setState(() {
          WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
          stateMessage = 'Seleccione un dispositivo.';
        });
      }
    });
  }

  Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: const Duration(seconds: 4));

    bool isConnected = await bluetoothPrint.isConnected ?? false;

    bluetoothPrint.state.listen((state) {
      print('************ device status: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            connected = true;
            stateMessage = 'Conectado correctamente.';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            connected = false;
            stateMessage = 'Desconectado correctamente.';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if (isConnected) {
      setState(() {
        connected = true;
      });
    }

    if (await Permission.bluetooth.isGranted) {
      final status = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
      ].request();
      if (status[Permission.bluetoothScan] != PermissionStatus.granted ||
          status[Permission.bluetoothConnect] != PermissionStatus.granted) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final printer = Provider.of<PrinterProvider>(context);
    final selectedProducts = Provider.of<SelectedProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: const Color(0xff3e4253),
        backgroundColor: Colors.transparent,
        actions: [
          StreamBuilder<bool>(
            stream: bluetoothPrint.isScanning,
            initialData: false,
            builder: (_, snapshot) {
              if (snapshot.data == true) {
                return IconButton(
                  icon: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.grey.shade300,
                      strokeWidth: 2,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      bluetoothPrint.stopScan();
                    });
                  },
                );
              }
              return IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  bluetoothPrint.state.listen((value) {
                    if (value == 12 && connected == false) {
                      setState(() {
                        initBluetooth();
                      });
                    } else {
                      null;
                    }
                  });
                },
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 30,
            width: double.infinity,
            child: Text(
              stateMessage,
              style: const TextStyle(
                color: Color(0xff3e4253),
              ),
            ),
          ),
          SingleChildScrollView(
            child: StreamBuilder<List<BluetoothDevice>>(
              stream: bluetoothPrint.scanResults,
              initialData: const [],
              builder: (_, snapshot) {
                return Column(
                  children: snapshot.data!
                      .map(
                        (deviceListened) => Padding(
                          padding: const EdgeInsets.all(10),
                          child: ListTile(
                            splashColor: connected &&
                                    device!.address == deviceListened.address
                                ? Colors.red.shade800
                                : Colors.green.shade700,
                            leading: const Icon(
                              Icons.bluetooth,
                              color: Color(0xff3e4253),
                              size: 25,
                            ),
                            title: Text(
                              deviceListened.name ?? '',
                              style: TextStyle(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            subtitle: Text(
                              deviceListened.address ?? '',
                              style: const TextStyle(
                                color: Color(0xff3e4253),
                              ),
                            ),
                            trailing: connected &&
                                    device!.address == deviceListened.address
                                ? Icon(
                                    Icons.check,
                                    color: Colors.green.shade700,
                                  )
                                : null,
                            onTap: connected
                                ? () async {
                                    // DESCONECTANDO DISPOSITIVO
                                    setState(() {
                                      stateMessage =
                                          'Desconectando de ${device!.name}...';
                                    });
                                    await bluetoothPrint.disconnect();
                                    printer.removeSavedPrinter();
                                  }
                                : () async {
                                    // CONECTANDO DISPOSITIVO
                                    device = deviceListened;
                                    if (device != null &&
                                        device!.address != null) {
                                      setState(() {
                                        stateMessage =
                                            'Conectando con ${device!.name}...';
                                      });
                                      await bluetoothPrint.connect(device!);
                                      printer.addSavedPrinter(
                                          device!.name.toString());
                                    } else {
                                      setState(() {
                                        stateMessage =
                                            'Seleccione un dispositivo.';
                                      });
                                    }
                                  },
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: !printer.isPrinting
          ? FloatingActionButton.extended(
              backgroundColor: connected
                  ? Colors.indigo
                  : const Color(0xff232333).withOpacity(0.5),
              label: const Text('Imprimir Ticket'),
              onPressed: connected
                  ? () async {
                      printer.printing();
                      await _startPrint(
                        bluetoothPrint,
                        selectedProducts.selectedProducts,
                        selectedProducts.qtySelected,
                        selectedProducts.total,
                      );
                      setState(() async {
                        stateMessage = 'Ticket impreso correctamente.';
                      });
                      printer.endPrinting();
                    }
                  : null,
            )
          : const SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                color: Colors.indigo,
                strokeWidth: 2,
              ),
            ),
    );
  }
}

Future<void> _startPrint(
  BluetoothPrint bluetoothPrint,
  List<SavedProduct> selectedProducts,
  int qty,
  int total,
) async {
  DateTime now = DateTime.now();
  final date = DateFormat('dd/MM/yyyy - hh:mm').format(now);
  Map<String, dynamic> config = {};

  List<LineText> list = [];

  list
    ..add(
      LineText(
        type: LineText.TYPE_TEXT,
        align: LineText.ALIGN_CENTER,
        content: '------------------------------------',
      ),
    )
    ..add(
      LineText(
        type: LineText.TYPE_TEXT,
        align: LineText.ALIGN_CENTER,
        content: 'MOZO APP',
        size: 15,
        linefeed: 1,
      ),
    )
    ..add(
      LineText(
        type: LineText.TYPE_TEXT,
        align: LineText.ALIGN_CENTER,
        content: '------------------------------------',
      ),
    );

  for (var i = 0; i <= selectedProducts.length; i++) {
    list
      ..add(
        LineText(
          type: LineText.TYPE_TEXT,
          content: selectedProducts[i].name,
          weight: 1,
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
        ),
      )
      ..add(
        LineText(
          type: LineText.TYPE_TEXT,
          align: LineText.ALIGN_LEFT,
          content: 'x${selectedProducts[i].qty}',
          linefeed: 1,
        ),
      )
      ..add(
        LineText(
          type: LineText.TYPE_TEXT,
          align: LineText.ALIGN_RIGHT,
          content: r'$' '${selectedProducts[i].price}',
          linefeed: 1,
        ),
      );
  }

  list
    ..add(
      LineText(
        type: LineText.TYPE_TEXT,
        align: LineText.ALIGN_RIGHT,
        content: 'Productos: $qty',
        linefeed: 1,
        size: 10,
      ),
    )
    ..add(
      LineText(
        type: LineText.TYPE_TEXT,
        align: LineText.ALIGN_RIGHT,
        content: r'Total: $' '$total',
        linefeed: 1,
        size: 10,
      ),
    )
    ..add(
      LineText(
        type: LineText.TYPE_TEXT,
        align: LineText.ALIGN_CENTER,
        content: '------------------------------------',
      ),
    )
    ..add(
      LineText(
        type: LineText.TYPE_TEXT,
        align: LineText.ALIGN_CENTER,
        content: 'Fecha: $date',
        size: 5,
        linefeed: 1,
      ),
    );

  await bluetoothPrint.printReceipt(config, list);
}
