import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisatabumnag/features/cart/presentation/blocs/cart_bloc.dart';
import 'package:wisatabumnag/features/cart/presentation/widgets/souvenir_cart_widget.dart';
import 'package:wisatabumnag/shared/widgets/wisata_divider.dart';

class CartListPage extends StatelessWidget {
  const CartListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Suvenir'),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  context.read<CartBloc>().add(
                        const CartEvent.saveToCartButtonPressed(),
                      );
                },
                tooltip: 'Simpan Perubahan Keranjang',
                icon: const Icon(
                  Icons.save_rounded,
                ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            return ListView.separated(
              separatorBuilder: (context, index) => const WisataDivider(),
              shrinkWrap: true,
              itemCount: state.cartSouvenir.length,
              itemBuilder: (context, index) {
                return SouvenirCartWidget(
                  cartSouvenir: state.cartSouvenir[index],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
