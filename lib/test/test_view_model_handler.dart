import 'package:flutter/material.dart';
import 'package:flutter_architecture/view_model_handler.dart';

class TestViewModelHandler extends StatefulWidget {
  const TestViewModelHandler({super.key});

  @override
  State<TestViewModelHandler> createState() => _TestViewModelHandlerState();
}

class _TestViewModelHandlerState extends State<TestViewModelHandler> {
  @override
  Widget build(BuildContext context) {
    return ViewModelHandler<ViewModel>(
      viewModel: ViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Test"),
        ),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              ViewModel vm = ViewModelHandler.of<ViewModel>(context);
              vm.increment();
            },
          );
        }),
        body: Builder(
          builder: (ctx) {
            ViewModel vm = ViewModelHandler.of<ViewModel>(ctx);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ValueListenableBuilder(
                      valueListenable: vm.value,
                      builder: (ctx, value, child) {
                        return Column(
                          children: [
                            Text("Current ViewModel hash: ${vm.hashCode}"),
                            Text("Button pressed: $value"),
                          ],
                        );
                      }),
                  ElevatedButton(
                    child: const Text("Next"),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const TestViewModelHandler(),
                      ));
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
