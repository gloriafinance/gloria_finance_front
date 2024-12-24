import 'package:church_finance_bk/auth/ui/widgets/FormLogin.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/IPUBLogo.dart';
import 'package:church_finance_bk/core/widgets/background_container.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedLanguage = 'pt'; // Idioma por defecto

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 16.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            title: const Text(
              'Dashboard',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            automaticallyImplyLeading: MediaQuery.of(context).size.width < 800,
            actions: [
              // Información del usuario
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          'Angel Bejarano', // Nombre del usuario
                          style: TextStyle(
                            fontFamily: AppFonts.fontMedium,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'angel.bejarano@jaspesoft.com',
                          // Correo electrónico del usuario
                          style: TextStyle(
                            color: Colors.black54,
                            fontFamily: AppFonts.fontLight,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.purple,
                      child: const Text(
                        'AB', // Iniciales del usuario
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              // Selector de idioma mejorado
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: PopupMenuButton<String>(
                  onSelected: (String value) {
                    setState(() {
                      selectedLanguage =
                          value; // Actualizar el idioma seleccionado
                    });
                    print("Idioma seleccionado: $value");
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'es',
                        child: ListTile(
                          leading: Icon(Icons.flag, color: Colors.red),
                          title: Text('Español'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'pt',
                        child: ListTile(
                          leading: Icon(Icons.flag, color: Colors.green),
                          title: Text('Português'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'en',
                        child: ListTile(
                          leading: Icon(Icons.flag, color: Colors.blue),
                          title: Text('English'),
                        ),
                      ),
                    ];
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.language, color: Colors.black54),
                      const SizedBox(width: 8),
                      Text(
                        selectedLanguage.toUpperCase(),
                        // Mostrar el código del idioma seleccionado
                        style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 18,
                            fontFamily: AppFonts.fontMedium),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: MediaQuery.of(context).size.width < 800
          ? const Drawer(
              child: Sidebar(),
            )
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLargeScreen = constraints.maxWidth >= 800;

          return Row(
            children: [
              // Sidebar fijo solo en pantallas grandes
              if (isLargeScreen)
                Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  width: 320,
                  child: const Sidebar(),
                ),
              // Contenido principal
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    //borderRadius: BorderRadius.circular(12.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 16.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const FormLogin(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundContainer(),
        Column(
          children: [
            Container(
              height: 180,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
              margin: const EdgeInsets.only(bottom: 30.0, top: 30.0),
              child: IPUBLogo(),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.dashboard, color: Colors.black),
                    title: const Text('Dashboard',
                        style: TextStyle(color: Colors.black)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.black),
                    title: const Text('Profile',
                        style: TextStyle(color: Colors.black)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.black),
                    title: const Text('Settings',
                        style: TextStyle(color: Colors.black)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.black),
                    title: const Text('Logout',
                        style: TextStyle(color: Colors.black)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
