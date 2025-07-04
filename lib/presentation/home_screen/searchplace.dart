// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jetrideruser/domain/geolocator/searchplacemodel.dart';
import 'package:jetrideruser/presentation/home_screen/bloc/geo_bloc.dart';
import 'package:jetrideruser/routes/app_routes.dart';

class Searchplace extends StatefulWidget {
  const Searchplace({super.key});

  @override
  State<Searchplace> createState() => _SearchplaceState();

  static Widget builder(BuildContext context) {
    return Searchplace();
  }
}

class _SearchplaceState extends State<Searchplace> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<GeoBloc, GeoState>(
      listener: (context, state) {
        if (state.formStatus is SubmissionFailed) {
          Navigator.of(context).pop();
          }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 181, 223, 244),
        body: Column(children: [
          Container(
            height: 180,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 72, 186, 247),
              boxShadow: [
                BoxShadow(
                    color: Colors.white,
                    blurRadius: 8,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7))
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 25.0),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Pesquise sua localizacao atual",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.adjust_sharp,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "Pequise aqui",
                            fillColor: Colors.white,
                            filled: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                              left: 11.0,
                              top: 8.0,
                              bottom: 8.0,
                            ),
                          ),
                          onChanged: (value) => context
                              .read<GeoBloc>()
                              .add(AddressChanged(address: value)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          BlocBuilder<GeoBloc, GeoState>(
            builder: (context, state) {
              if (state.formStatus is Formchanging) {
                final places = (state.formStatus as Formchanging).places;
                return Expanded(
                  child: ListView.separated(
                    itemCount: places.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      color: Colors.white,
                      thickness: 1,
                    ),
                    itemBuilder: (context, index) {
                      return PlacePredictionsTile(
                          predictionsPlace: places[index]);
                    },
                  ),
                );
              } else if (state.formStatus is FormSubmitting) {
                return Container(
                  padding: const EdgeInsets.only(top: 200),
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                );
              } else {
                return Center(child: Container());
              }
            },
          )
        ]),
      ),
    );
  }
}

class PlacePredictionsTile extends StatelessWidget {
  final SearchplaceModel? predictionsPlace;

  const PlacePredictionsTile({
    super.key,
    this.predictionsPlace,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
          context
              .read<GeoBloc>()
              .add(NewAddressSubmitted(predictionsPlace: predictionsPlace));
        },
        child: Row(
          children: [
            const Icon(
              Icons.add_location,
              color: Colors.black,
            ),
            const SizedBox(width: 14.0),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  predictionsPlace?.mainText ?? "erro na busca",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                Text(predictionsPlace?.secondaryText ?? "erro na busca",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                    ))
              ],
            ))
          ],
        ));
  }
}
