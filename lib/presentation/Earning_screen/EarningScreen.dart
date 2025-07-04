import 'package:brasil_fields/brasil_fields.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jetrideruser/domain/firebase_auth/firebaseAuthManager.dart';
import 'package:jetrideruser/presentation/Earning_screen/bloc/card_register_bloc.dart';
import 'package:jetrideruser/presentation/botton_navigator/bottonNavigator.dart';
import 'package:jetrideruser/presentation/progress_dialog/progress_dialog.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EarningScreen extends StatelessWidget {
  EarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CardRegisterBloc(authRepo: context.read<EmailAndPassAuth>()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cadastrar cartão'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        bottomNavigationBar: CustomBottomNavigator(),
        body: ListView(
          children: [BodyPayment()]),
      ),
    );
  }
}

class BodyPayment extends StatelessWidget {
  BodyPayment({super.key});

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

    final FocusNode numberFocus = FocusNode();
    final FocusNode dateFocus = FocusNode();
    final FocusNode nameFocus = FocusNode();
    final FocusNode cvvFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CardRegisterBloc, CardRegisterState>(
      listener: (context, state) {
        if (state.formStatus is FormSubmitting) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return ProgressDialog(message: "Carregando, por favor espere");
            },
          );
        } else if (state.formStatus is SubmissionSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Cartão cadastrado com sucesso!")),
          );
        } else if (state.formStatus is SubmissionFailed) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text((state.formStatus as SubmissionFailed).exception)),
          );
        }
      },
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: 350,
              child: FlipCard(
                key: cardKey,
                flipOnTouch: false,
                direction: FlipDirection.HORIZONTAL,
                speed: 700,
                front: CardFront(
                  numberFocus: numberFocus,
                  dateFocus: dateFocus,
                  nameFocus: nameFocus,
                  finishedFront: () {
                    cardKey.currentState!.toggleCard();
                    cvvFocus.requestFocus();
                  },
                ),
                back: CardBack(cvvFocus: cvvFocus),
              ),
            ),
          ),
          TextButton(
            onPressed: () => cardKey.currentState!.toggleCard(),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(Colors.white),
            ),
            child: const Text('Virar cartão'),
          ),
          CPFField(),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      const Color.fromARGB(255, 4, 125, 141),
                    ),
                  ),
                  onPressed: () {
                    context.read<CardRegisterBloc>().add(RegisterSubmited());
                  },
                  child: const Text(
                    'Cadastrar cartão',
                    style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      );
    }
  }

class CardFront extends StatelessWidget {
  CardFront({
    required this.numberFocus,
    required this.dateFocus,
    required this.nameFocus,
    required this.finishedFront,
    super.key,
  });

  final VoidCallback finishedFront;
  final FocusNode numberFocus;
  final FocusNode dateFocus;
  final FocusNode nameFocus;
  final dateFormatter = MaskTextInputFormatter(
    mask: "##/####",
    filter: {"#": RegExp('[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 16,
      child: BlocBuilder<CardRegisterBloc, CardRegisterState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(16),
            height: 320,
            color: const Color(0xFF1B4852),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CardTextField(
                        title: "Número",
                        bold: true,
                        hint: "0000 0000 0000 0000",
                        textInputType: TextInputType.number,
                        maxLength: 19,
                        textAlign: TextAlign.start,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CartaoBancarioInputFormatter(),
                        ],
                        validator: (value) => state.isValidcardNumber ? null : 'Número inválido',
                        onChange: (value) => context.read<CardRegisterBloc>().add(
                              CardNumberChanged(cardNumber: value),
                            ),
                        focusNode: numberFocus,
                        onSubmitted: (_) => dateFocus.requestFocus(),
                      ),
                      CardTextField(
                        title: "Validade",
                        bold: false,
                        hint: "12/2020",
                        textInputType: TextInputType.number,
                        inputFormatters: [dateFormatter],
                        maxLength: 7,
                        textAlign: TextAlign.start,
                        validator: (value) => state.isValidvalid ? null : 'Validade inválida',
                        onChange: (value) => context.read<CardRegisterBloc>().add(
                              ValidChanged(valid: value),
                            ),
                        focusNode: dateFocus,
                        onSubmitted: (_) => nameFocus.requestFocus(),
                      ),
                      CardTextField(
                        title: "Titular",
                        bold: true,
                        hint: "João da Silva",
                        maxLength: null,
                        textInputType: TextInputType.text,
                        textAlign: TextAlign.start,
                        inputFormatters: [],
                        validator: (value) => state.isValidvalid ? null : 'Nome inválido',
                        onChange: (value) => context.read<CardRegisterBloc>().add(
                              OwnerChanged(owner: value),
                            ),
                        focusNode: nameFocus,
                        onSubmitted: (_) => finishedFront(),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.credit_card,
                    color: Colors.white,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class CardBack extends StatelessWidget {
  const CardBack({required this.cvvFocus, super.key});

  final FocusNode cvvFocus;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 16,
      child: BlocBuilder<CardRegisterBloc, CardRegisterState>(
        builder: (context, state) {
          return Container(
            height: 320,
            color: const Color(0xFF184852),
            child: Column(
              children: [
                Container(
                  color: Colors.black,
                  height: 40,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: CardTextField(
                    title: "CVM",
                    bold: false,
                    hint: "123",
                    maxLength: 3,
                    textInputType: TextInputType.number,
                    textAlign: TextAlign.end,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) => state.isValidCVM ? null : 'CVM inválido',
                    onChange: (value) => context.read<CardRegisterBloc>().add(
                          CVVChanged(cvv: value),
                        ),
                    focusNode: cvvFocus,
                    onSubmitted: (_) {},
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CPFField extends StatelessWidget {
  CPFField({super.key});

  final cpfFormatter = MaskTextInputFormatter(
    mask: "###.###.###-##",
    filter: {"#": RegExp('[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardRegisterBloc, CardRegisterState>(
      builder: (context, state) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "CPF",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(hintText: "000.000.000-00"),
                        maxLength: 14,
                        inputFormatters: [cpfFormatter],
                        validator: (value) => state.isValidCPF ? null : 'CPF inválido',
                        onChanged: (value) => context.read<CardRegisterBloc>().add(
                                CPFChanged(cpf: value),
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  if (state.isValidCPF != true)
                   const Text("CPF invalido",
                     style: TextStyle(color: Colors.red, fontSize: 9),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CardTextField extends StatelessWidget {
  final String title;
  final String hint;
  final bool bold;
  final int? maxLength;
  final TextAlign textAlign;
  final TextInputType textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChange;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;

  const CardTextField({
    super.key,
    required this.title,
    required this.hint,
    this.bold = false,
    this.maxLength,
    this.textAlign = TextAlign.start,
    required this.textInputType,
    this.inputFormatters,
    this.validator,
    this.onChange,
    this.focusNode,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              if (validator != null)
                Builder(
                  builder: (context) {
                    final errorText = validator!("");
                    return errorText == null
                        ? const SizedBox.shrink()
                        : Text(
                            errorText,
                            style: const TextStyle(color: Colors.red, fontSize: 12),
                          );
                  },
                ),
            ],
          ),
          TextFormField(
            keyboardType: textInputType,
            maxLength: maxLength,
            textAlign: textAlign,
            inputFormatters: inputFormatters,
            validator: validator,
            onChanged: onChange,
            focusNode: focusNode,
            onFieldSubmitted: onSubmitted,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white54),
              counterText: "",
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

