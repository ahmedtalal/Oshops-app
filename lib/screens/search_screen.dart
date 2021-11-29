import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/business_logic/cubit/api_services/api_services_cubit.dart';
import 'package:shop_app/constants/toast_constant.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? item;
  List<Map<String, dynamic>> products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 25,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Find your items",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 250,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'search about your items',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 18,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 0.4,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 0.4,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 0.4,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          item = value.toString();
                        });
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await CacheHelper.init();
                      var access_token =
                          CacheHelper.getData(key: 'access_token');
                      print("the token is $access_token");
                      ApiServicesCubit.getInstance(context).searchItem(
                        token: access_token,
                        param: item!,
                      );
                    },
                    child: BlocBuilder<ApiServicesCubit, ApiServicesStates>(
                      builder: (context, state) {
                        if (state is SearchItemFoundState) {
                          products = state.items;
                          products.sort(); // sort items from shotest to longest
                        } else if (state is SearchItemNotFoundState) {
                          ToastConstant.showToast(context, state.error);
                        }
                        return Container(
                          width: 60,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 20,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              ///**
              /// هشام هنا هتعمل ليست فيو ويدجيت وتنادي فيها علي اللسته
              ///  بعد معملتلها سورت هتلاقيها فوق سطر 109
              /// وبعد كدا هترسم شكل للداتا بس دا كل الي هتعمله هنا
              /// */
            ],
          ),
        ),
      ),
    );
  }
}
