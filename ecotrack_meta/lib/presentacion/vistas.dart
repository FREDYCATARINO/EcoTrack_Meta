import 'package:flutter/material.dart';
import '../dominio/consumo.dart';

class FormularioRegistro extends StatefulWidget {
  const FormularioRegistro({
    super.key,
    required this.alGuardar,
    required this.error,
    required this.guardando,
  });

  final Future<bool> Function(String laboratorio, String litros) alGuardar;
  final String? error;
  final bool guardando;

  @override
  State<FormularioRegistro> createState() => _FormularioRegistroState();
}

class _FormularioRegistroState extends State<FormularioRegistro> {
  String _laboratorioSeleccionado = laboratoriosUtez.first;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _laboratorioSeleccionado,
            items: laboratoriosUtez
                .map((lab) => DropdownMenuItem(value: lab, child: Text(lab)))
                .toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _laboratorioSeleccionado = val;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          TextField(
            key: const Key('litros'),
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Litros',
              errorText: widget.error,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: widget.guardando
                ? null
                : () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final exito = await widget.alGuardar(
                      _laboratorioSeleccionado,
                      _controller.text,
                    );
                    if (!mounted) return;
                    if (exito) {
                      _controller.clear();
                      messenger.showSnackBar(
                        const SnackBar(content: Text('Consumo guardado')),
                      );
                    }
                  },
            child: widget.guardando
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}

class ListaHistorial extends StatelessWidget {
  const ListaHistorial({
    super.key,
    required this.consumos,
    required this.total,
  });

  final List<Consumo> consumos;
  final double total;

  @override
  Widget build(BuildContext context) {
    if (consumos.isEmpty) {
      return const Center(child: Text('Sin consumos'));
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Total: ${total.toStringAsFixed(1)} L',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: consumos.length,
            itemBuilder: (context, index) {
              final c = consumos[index];
              return ListTile(
                title: Text(c.laboratorio),
                trailing: Text('${c.litros} L'),
              );
            },
          ),
        ),
      ],
    );
  }
}

class PanelMeta extends StatelessWidget {
  const PanelMeta({
    super.key,
    required this.usado,
    required this.meta,
    required this.avance,
    required this.superada,
    required this.alSubir,
    required this.alBajar,
  });

  final double usado;
  final double meta;
  final double avance;
  final bool superada;
  final VoidCallback alSubir;
  final VoidCallback alBajar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Usado: ${usado.toStringAsFixed(1)} de ${meta.toStringAsFixed(1)} L',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(value: avance),
          const SizedBox(height: 16),
          Text(
            superada ? 'Te pasaste de la meta' : 'Dentro de la meta',
            style: TextStyle(
              fontSize: 16,
              color: superada ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                key: const Key('bajarMeta'),
                onPressed: alBajar,
                child: const Text('Bajar meta'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                key: const Key('subirMeta'),
                onPressed: alSubir,
                child: const Text('Subir meta'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PantallasEcoTrack extends StatefulWidget {
  const PantallasEcoTrack({
    super.key,
    required this.titulo,
    required this.registro,
    required this.historial,
    required this.meta,
  });

  final String titulo;
  final Widget registro;
  final Widget historial;
  final Widget meta;

  @override
  State<PantallasEcoTrack> createState() => _PantallasEcoTrackState();
}

class _PantallasEcoTrackState extends State<PantallasEcoTrack> {
  int _indiceActual = 0;

  @override
  Widget build(BuildContext context) {
    final pantallas = [widget.registro, widget.historial, widget.meta];

    return Scaffold(
      appBar: AppBar(title: Text(widget.titulo)),
      body: IndexedStack(
        index: _indiceActual,
        children: pantallas,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceActual,
        onTap: (index) {
          setState(() {
            _indiceActual = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Registro',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Meta',
          ),
        ],
      ),
    );
  }
}
