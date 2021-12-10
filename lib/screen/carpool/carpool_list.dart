import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_final_project/model/carpool.dart';
import 'package:mobile_app_final_project/state/application_state.dart';
import 'package:provider/provider.dart';
import '../../state/carpool_state.dart';

class CarpoolListPage extends StatelessWidget {
  const CarpoolListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<CarpoolState>(
        builder: (context, carpoolState, _) => const CarpoolListView()
      ),
    );
  }
}

class CarpoolListView extends StatefulWidget {
  const CarpoolListView({Key? key, }) : super(key: key);

  @override
  State<CarpoolListView> createState() => _CarpoolListViewState();
}

class _CarpoolListViewState extends State<CarpoolListView> {
  TextStyle titleStyle = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold
  );

  TextStyle contentStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) => Consumer<CarpoolState>(
        builder: (context, carpoolState, _) => ListView.builder(
          itemCount: carpoolState.carpool.length,
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (BuildContext context, int index) {
            return Card(
              clipBehavior: Clip.antiAlias,
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.black, width: 1)
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10.0),
                onTap: () => {
                  carpoolState.setSelectedCarpool(carpoolState.carpool[index]),
                  appState.changePageIndex(6),
                },
                title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                                children: [
                                  Text(carpoolState.carpool[index].startLocation, style: titleStyle,),
                                  Text(carpoolState.carpool[index].startLocationDetail, style: contentStyle,),
                                ],
                              )
                          ),
                          const Icon(Icons.arrow_forward_rounded),
                          Expanded(
                              child: Column(
                                children: [
                                  Text(carpoolState.carpool[index].endLocation, style: titleStyle,),
                                  Text(carpoolState.carpool[index].endLocationDetail, style: contentStyle,),
                                ],
                              )
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Text(DateFormat("yyyy-MM-dd HH:mm").format(carpoolState.carpool[index].departureTime), style: contentStyle,),
                          ),
                          Text(carpoolState.carpool[index].fee.toString() + '원 - ', style: contentStyle,),
                          Text(carpoolState.carpool[index].currentNum.toString() + ' / ' + carpoolState.carpool[index].maxNum.toString(), style: contentStyle,),
                        ],
                      ),
                    ]
                ),
              ),
            );
          },
        )
      )
    );
  }
}