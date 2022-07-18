import 'package:flutter/material.dart';

import '../storage/db_repository.dart';

class Data with ChangeNotifier {
  final DBRepository _base = DBRepository();

  Map toJson() {
    return {
      'data': {
        'Grupo 0': {'name': 'Especiales', 'from': 0, 'to': 9},
        'Grupo 1': {
          'name': 'Grupo A',
          'countries': {
            'Qatar': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 10,
              'to': 35,
            },
            'Países Bajos': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 36,
              'to': 61,
            },
            'Senegal': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 62,
              'to': 87,
            },
            'Ecuador': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 88,
              'to': 103,
            },
          }
        },
        'Grupo 2': {
          'name': 'Grupo B',
          'countries': {
            'Inglaterra': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 104,
              'to': 129,
            },
            'Estados Unidos': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 130,
              'to': 155,
            },
            'Irán': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 156,
              'to': 181,
            },
            'Gales': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 182,
              'to': 207,
            },
          },
        },
        'Grupo 3': {
          'name': 'Grupo C',
          'countries': {
            'Argentina': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 208,
              'to': 233,
            },
            'México': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 234,
              'to': 259,
            },
            'Polonia': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 260,
              'to': 285,
            },
            'Arabia Saudita': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 286,
              'to': 311,
            },
          },
        },
        'Grupo 4': {
          'name': 'Grupo D',
          'countries': {
            'Francia': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 312,
              'to': 337,
            },
            'Dinamarca': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 338,
              'to': 363,
            },
            'Túnez': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 364,
              'to': 389,
            },
            'Australia': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 390,
              'to': 415,
            },
          },
        },
        'Grupo 5': {
          'name': 'Grupo E',
          'countries': {
            'España': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 416,
              'to': 431,
            },
            'Alemania': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 432,
              'to': 457,
            },
            'Japón': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 458,
              'to': 483,
            },
            'Costa Rica': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 484,
              'to': 509,
            },
          },
        },
        'Grupo 6': {
          'name': 'Grupo F',
          'countries': {
            'Bélgica': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 510,
              'to': 535,
            },
            'Croacia': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 536,
              'to': 561,
            },
            'Marruecos': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 562,
              'to': 587,
            },
            'Canadá': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 588,
              'to': 603,
            },
          },
        },
        'Grupo 7': {
          'name': 'Grupo G',
          'countries': {
            'Brasil': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 604,
              'to': 629,
            },
            'Suiza': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 630,
              'to': 655,
            },
            'Serbia': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 656,
              'to': 681,
            },
            'Camerún': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 682,
              'to': 707,
            },
          },
        },
        'Grupo 8': {
          'name': 'Grupo H',
          'countries': {
            'Portugal': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 708,
              'to': 733,
            },
            'Uruguay': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 734,
              'to': 759,
            },
            'Corea del Sur': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 760,
              'to': 785,
            },
            'Ghana': {
              'img': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Qatar.svg/1200px-Flag_of_Qatar.svg.png',
              'from': 786,
              'to': 811,
            },
          },
        },
      },
    };
  }

  Future<void> getData() async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      var config = await _base.get("configApp");
      if (config.isEmpty) {
        _base.set('data', toJson());
        notifyListeners();
      } else {
        await Future.delayed(const Duration(seconds: 5), () => _base.set('data', toJson()));
        notifyListeners();
      }
    } catch (e) {
      print("Error al preparar app config. " + e.toString());
    }
  }
}
