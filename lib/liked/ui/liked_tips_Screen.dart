

import 'package:flutter/material.dart';
// import 'package:flutter_application_0/bloc/liked_bloc/bloc/liked_bloc.dart';
import 'package:flutter_application_0/liked/bloc/liked_bloc.dart';
// import 'package:flutter_application_0/liked_bloc/widgets/liked_tip_card.dart';
import 'package:flutter_application_0/widgets/liked_tip_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Liked extends StatefulWidget {
  const Liked({Key? key}) : super(key: key);

  @override
  State<Liked> createState() => _LikedState();
}

class _LikedState extends State<Liked> {
  final LikedBloc likedBloc = LikedBloc();

  @override
  void initState() {
    likedBloc.add(LikedinitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liked Items'),
      ),
      body: BlocConsumer<LikedBloc, LikedState>(
        bloc: likedBloc,
        listener: (context, state) {
          // TODO: Implement listener if needed
        },
        listenWhen: (previous, current) => current is LikedActionState,
        buildWhen: (previous, current) => current is! LikedActionState,
        builder: (context, state) {
          switch (state.runtimeType) {
            case LikedSucessState:
              final successState = state as LikedSucessState;
              return ListView.builder(
                itemCount: successState.likeditems.length,
                itemBuilder: (context, index) {
                  final tip = successState.likeditems[index];
                  print('lfklasfkljaslfjlasdjfljasf${successState.likeditems.length}');
                  return LikedtileWidget(
                    healthTipDataModel: tip,
                    likedBloc: likedBloc,
                    heading: tip.heading,
                    id: tip.id,
                    description: tip.description,
                    imageUrl: tip.imageUrl,
                  );
                },
              );
              break;
            default:
              return Container();
          }
        },
      ),
    );
  }
}
