import 'package:app4_receitas/ui/widgets/custom_bnb.dart';
import 'package:app4_receitas/utils/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BaseScreen extends StatefulWidget {
  final Widget child;

  const BaseScreen({super.key, required this.child});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final controller = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.loadUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Eu Amo Cozinhar', style: GoogleFonts.dancingScript()),
              Obx(() {
                final user = controller.user.value;
                if (user == null) {
                  return const CircleAvatar(child: Icon(Icons.person));
                }
                return ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    user.avatarUrl,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress == null
                        ? child
                        : Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                    errorBuilder: (context, child, stackTrace) => Container(
                      height: 60,
                      width: 60,
                      color: Theme.of(context).colorScheme.primary,
                      child: Icon(Icons.error),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      body: widget.child,
      // endDrawer: const CustomDrawer(),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}