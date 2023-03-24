import 'package:consus_erp/Model/Orders/get_orders.dart';
import 'package:consus_erp/Providers/OrdersProvider/orders_provider.dart';
import 'package:consus_erp/Providers/UserAuth/login_provider.dart';
import 'package:consus_erp/Views/Orders/add_new_orders.dart';
import 'package:consus_erp/Views/Orders/orders_card.dart';
import 'package:consus_erp/Widgets/form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class OrdersList extends StatefulWidget {
  const OrdersList({Key? key}) : super(key: key);

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {

  late OrdersProvider ordersProvider;

  @override
  void initState() {
    // TODO: implement initState
    ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    ordersProvider.getOrdersFromLocal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Orders List',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Get.to(()=> AddNewOrders());
                },
                icon: Icon(Icons.add),
                label: Text('Orders'),
              ),
            ],
          )),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// USER NAME

            Text(
              LoginProvider.getUser().fullName ?? "",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 10),

            /// Search From Orders List

            Consumer<OrdersProvider>(
              builder: (BuildContext context, value, Widget? child){
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: AppFormField(
                            labelText: "Search Orders",
                            prefixIcon: Icon(Icons.search_sharp, color: Colors.grey,),
                            onChanged: (val){
                              value.searchOrders(val);
                            },
                          ),
                        ),
                      ],
                    );
              },
            ),

            /// Orders List

            Expanded(
                child: Consumer<OrdersProvider>(
                  builder: (BuildContext context, value, Widget? child){
                    return value.getOrdersData!.data!.isNotEmpty == true
                        ? ListView.builder(
                          itemCount: value.getOrdersData == null ? 0 : value.getOrdersData!.data!.length,
                          itemBuilder: (BuildContext context, int index){
                            final OrdersModel? order = value.getOrdersData?.data![index];

                            if(order?.TotalRows != 0 && order?.shopName != null
                            && order!.shopName!.toLowerCase().contains(value.txtSearchOrders.text.toLowerCase())
                            || value.txtSearchOrders.text.isEmpty)
                              {
                                return Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: OrdersCard(ordersModel: order, index: index+1,),
                                );
                              }
                            else
                              {
                                return SizedBox.shrink();
                              }
                          },
                        )
                        :
                        noDataFound();
                  },
                ),
            ),
          ],
        ),
      ),
    );
  }
  /// NO DATA FOUND
  Widget noDataFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "NO DATA FOUND",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          Text(
            "Please Sync Orders And Shops First.",
            style: TextStyle(color: Colors.grey.withOpacity(.5)),
          )
        ],
      ),
    );
  }
}
