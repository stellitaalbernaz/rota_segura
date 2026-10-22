import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const RotaSeguraApp());
}

class RotaSeguraApp extends StatelessWidget {
  const RotaSeguraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rota Segura',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          primary: const Color(0xFF0D47A1),
        ),
        useMaterial3: true,
      ),
      home: const DriverHomePage(),
    );
  }
}

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  bool _isOnline = false;
  double _ganhosDoDia = 125.50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Text('Rota Segura'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: () => _mostrarCalculadora(context),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryPage()),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(-23.5505, -46.6333),
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                // ESTA LINHA ABAIXO RESOLVE O "ACCESS BLOCKED"
                userAgentPackageName: 'com.stellita_albernaz.rotasegura.app',
              ),
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: const LatLng(-23.5505, -46.6333),
                    color: Colors.red.withOpacity(0.3),
                    borderStrokeWidth: 2,
                    borderColor: Colors.red,
                    useRadiusInMeter: true,
                    radius: 800,
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'panic',
                  onPressed: () => _mostrarAlertaPanico(context),
                  backgroundColor: Colors.red,
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                FloatingActionButton(
                  heroTag: 'report',
                  onPressed: () => _mostrarFormularioReporte(context),
                  backgroundColor: Colors.orange,
                  child: const Icon(
                    Icons.add_location_alt,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          _buildPainelInferior(),
        ],
      ),
    );
  }

  Widget _buildPainelInferior() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 150,
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Ganhos Atuais: R\$ ${_ganhosDoDia.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => setState(() => _isOnline = !_isOnline),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isOnline ? Colors.red : Colors.blue[900],
                  foregroundColor: Colors.white,
                ),
                child: Text(_isOnline ? "ENCERRAR TURNO" : "FICAR ONLINE"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarCalculadora(BuildContext context) {
    final TextEditingController brutoCtrl = TextEditingController();
    final TextEditingController gastoCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Calculadora de Lucro"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: brutoCtrl,
              decoration: const InputDecoration(
                labelText: "Ganhos Brutos (R\$)",
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: gastoCtrl,
              decoration: const InputDecoration(labelText: "Gastos"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("VOLTAR"),
          ),
          ElevatedButton(
            onPressed: () {
              double lucro =
                  (double.tryParse(brutoCtrl.text) ?? 0) -
                  (double.tryParse(gastoCtrl.text) ?? 0);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Lucro: R\$ ${lucro.toStringAsFixed(2)}"),
                ),
              );
            },
            child: const Text("CALCULAR"),
          ),
        ],
      ),
    );
  }

  void _mostrarFormularioReporte(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Reportar Local",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const TextField(
              decoration: InputDecoration(labelText: "O que aconteceu?"),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("SEGURA"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("RISCO"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _mostrarAlertaPanico(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Icon(Icons.warning, color: Colors.red, size: 40),
        content: const Text(
          "SOS - Chamar Polícia?",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("NÃO"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "SIM, ENVIAR",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico')),
      body: const Center(child: Text("Lista de viagens anteriores.")),
    );
  }
}
