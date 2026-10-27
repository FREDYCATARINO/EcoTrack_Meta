import 'package:flutter/foundation.dart';
import '../datos/consumo_repository.dart';
import '../dominio/consumo.dart';
import '../dominio/meta.dart';

class ConsumosViewModel extends ChangeNotifier {
  final ConsumoRepository _repositorio;

  ConsumosViewModel(this._repositorio);

  List<Consumo> consumos = [];
  String? error;
  bool guardando = false;
  double meta = metaInicial;

  double get total {
    double sum = 0.0;
    for (final c in consumos) {
      sum += c.litros;
    }
    return sum;
  }

  double get avance => avanceDeMeta(total: total, meta: meta);

  bool get metaSuperada => total > meta;

  Future<void> cargar() async {
    consumos = await _repositorio.todos();
    notifyListeners();
  }

  Future<bool> guardar(String laboratorio, String litrosTexto) async {
    final limpio = litrosTexto.trim().replaceAll(',', '.');
    final litrosParsed = double.tryParse(limpio);

    final err = validarLitros(litrosParsed);
    if (err != null) {
      error = err;
      notifyListeners();
      return false;
    }

    guardando = true;
    error = null;
    notifyListeners();

    await _repositorio.guardar(Consumo(laboratorio: laboratorio, litros: litrosParsed!));
    consumos = await _repositorio.todos();

    guardando = false;
    notifyListeners();
    return true;
  }

  void subirMeta() {
    meta = ajustarMeta(meta, pasoMeta);
    notifyListeners();
  }

  void bajarMeta() {
    meta = ajustarMeta(meta, -pasoMeta);
    notifyListeners();
  }
}
