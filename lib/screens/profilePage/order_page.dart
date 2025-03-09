import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tech_barter/components/custom_scaffold.dart';
import 'package:tech_barter/components/custom_container.dart';
import 'package:tech_barter/models/order_response.dart';
import 'package:tech_barter/providers/order_provider.dart';
import 'package:tech_barter/screens/profilePage/components/profile_side_menu.dart';
import 'package:tech_barter/screens/profilePage/components/status_chip.dart';


class OrderPage extends StatefulWidget {

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  @override
  void initState() {
    Provider.of<OrderProvider>(context, listen: false).fetchOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 64, vertical: 32),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: ProfileSideMenu( index: 2),
            ),

            Expanded(
              flex: 8,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Orders',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Consumer<OrderProvider>(
                        builder: (context, orderProvider, child) {
                          if(orderProvider.orderResponses.isEmpty) return const Center(child: CircularProgressIndicator());
                          return ListView.builder(
                            itemCount: orderProvider.orderResponses.length,
                            itemBuilder: (context, index) {
                              OrderResponse orderRes = orderProvider.orderResponses.elementAt(index);
                              return _buildOrderCard(orderRes, context);
                            },
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderResponse orderRes, BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    DateTime? orderDate = orderRes.order.orderDate != null
        ? DateTime.parse(orderRes.order.orderDate!)
        : null;
    DateTime? deliveryDate = orderRes.order.deliveryDate != null
        ? DateTime.parse(orderRes.order.deliveryDate!)
        : null;

    return CustomContainer(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('Status: ', style: TextStyle(color: Colors.grey)),
                  StatusChip(status: orderRes.order.status ?? 'Unknown'),
                ],
              ),

              if(orderRes.order.status == "PENDING")
                InkWell(
                  onTap: () {
                    _showCancelDialog(context, orderRes.order.id.toString());
                  },
                  child: StatusChip(status: "Cancel Order"),
                )
            ],
          ),
          const SizedBox(height: 12),
          Text(
            orderRes.product?.name ?? 'Unknown Product',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Quantity: ', style: TextStyle(color: Colors.grey)),
              Text('${orderRes.order.soldQuantity}'),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Order Date', style: TextStyle(color: Colors.grey)),
                  if (orderDate != null)
                    Text(dateFormat.format(orderDate)),
                ],
              ),
              if (deliveryDate != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Deliver On', style: TextStyle(color: Colors.grey)),
                    Text(dateFormat.format(deliveryDate)),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Subtotal', style: TextStyle(color: Colors.grey)),
                  Text('\$${(orderRes.order.amount ?? 0).toStringAsFixed(2)}'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tax', style: TextStyle(color: Colors.grey)),
                  Text('\$${(orderRes.order.taxAmount ?? 0).toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    '\$${(orderRes.order.totalAmount ?? 0).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }


  void _showCancelDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Cancel Order #${orderId}"),
          content: Text("Are you sure you want to cancel this order?"),
          actions: [
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () async {
                await Provider.of<OrderProvider>(context, listen: false).cancelOrder(orderId);
                Navigator.of(context).pop(); // Close the dialog

                // Show confirmation message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Order cancelled successfully")),
                );
              },
            ),
          ],
        );
      },
    );
  }
}