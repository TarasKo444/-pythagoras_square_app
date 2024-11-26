import 'package:dart_openai/dart_openai.dart';
import 'package:get_it/get_it.dart';
import 'package:pythagoras_square_app/main.dart';

import 'pythagorean_square_service.dart';

final class SummarizationService {
  SummarizationService() {
    OpenAI.apiKey = Environment.aiApiKey;
  }

  Future<String> summarize(Result result) async {
    final pSService = GetIt.I<PythagoreanSquareService>();
    final descriptions = <String>[];

    for (final characteristic in result.matrix.values) {
      descriptions
          .add(await pSService.getNumerologyDescription(characteristic));
    }

    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          "Based on next user`s description, provide him whole summarization of this characteristics",
        ),
      ],
      role: OpenAIChatMessageRole.system,
    );

    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          descriptions.join('\n\n'),
        ),
      ],
      role: OpenAIChatMessageRole.user,
    );

    final requestMessages = [
      systemMessage,
      userMessage,
    ];

    var future = OpenAI.instance.chat.create(
      model: "gpt-4",
      seed: 6,
      messages: requestMessages,
      temperature: 0.2,
      maxTokens: 500,
    );

    return future.then((r) => r.choices.first.message.content!.first.text!);
  }
}
