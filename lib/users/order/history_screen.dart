import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../api_connection/api_connection.dart';
import '../model/order.dart';
import '../userPreferences/current_user.dart';
import 'order_details.dart';





class HistoryScreen extends StatelessWidget
{
  final currentOnlineUser = Get.put(CurrentUser());


  Future<List<Order>> getCurrentUserOrdersList() async
  {
    List<Order> ordersListOfCurrentUser = [];

    try
    {
      var res = await http.post(
          Uri.parse(API.readHistory),
          body:
          {
            "currentOnlineUserID": currentOnlineUser.user.user_id.toString(),
          }
      );

      if (res.statusCode == 200)
      {
        var responseBodyOfCurrentUserOrdersList = jsonDecode(res.body);

        if (responseBodyOfCurrentUserOrdersList['success'] == true)
        {
          (responseBodyOfCurrentUserOrdersList['currentUserOrdersData'] as List).forEach((eachCurrentUserOrderData)
          {
            ordersListOfCurrentUser.add(Order.fromJson(eachCurrentUserOrderData));
          });
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    }
    catch(errorMsg)
    {
      Fluttertoast.showToast(msg: "Error:: " + errorMsg.toString());
    }

    return ordersListOfCurrentUser;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 8, 0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/images/history_icon.png",
                      width: 140,
                    ),
                  ),
                  const Text(
                    "My History",
                    style: TextStyle(
                      color: Colors.purpleAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          //some info
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                "Here are your successfully received parcels.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),

          //displaying the user orderList
          Expanded(
            child: displayOrdersList(context),
          ),

        ],
      ),
    );
  }

  Widget displayOrdersList(context)
  {
    return FutureBuilder(
      future: getCurrentUserOrdersList(),
      builder: (context, AsyncSnapshot<List<Order>> dataSnapshot)
      {
        if(dataSnapshot.connectionState == ConnectionState.waiting)
        {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Center(
                child: Text(
                  "Connection Waiting...",
                  style: TextStyle(color: Colors.grey,),
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }
        if(dataSnapshot.data == null)
        {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Center(
                child: Text(
                  "No orders found yet...",
                  style: TextStyle(color: Colors.grey,),
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }
        if(dataSnapshot.data!.length > 0)
        {
          List<Order> orderList = dataSnapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index)
            {
              return const Divider(
                height: 1,
                thickness: 1,
              );
            },
            itemCount: orderList.length,
            itemBuilder: (context, index)
            {
              Order eachOrderData = orderList[index];

              return Card(
                color: Colors.white24,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: ListTile(
                    onTap: ()
                    {
                      Get.to(OrderDetailsScreen(
                        clickedOrderInfo: eachOrderData,
                      ));
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order ID # " + eachOrderData.order_id.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Amount: \$ " + eachOrderData.totalAmount.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.purpleAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        //date
                        //time
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            //date
                            Text(
                              DateFormat(
                                  "dd MMMM, yyyy"
                              ).format(eachOrderData.dateTime!),
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 4),

                            //time
                            Text(
                              DateFormat(
                                  "hh:mm a"
                              ).format(eachOrderData.dateTime!),
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),

                          ],
                        ),

                        const SizedBox(width: 6),

                        const Icon(
                          Icons.navigate_next,
                          color: Colors.purpleAccent,
                        ),

                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
        else
        {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Center(
                child: Text(
                  "Nothing to show...",
                  style: TextStyle(color: Colors.grey,),
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }
      },
    );
  }
}
