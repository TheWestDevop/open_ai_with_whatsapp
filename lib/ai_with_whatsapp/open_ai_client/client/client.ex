defmodule OpenAIClient.Client do
  alias OpenAIClient.Client.AuthenticatedAPI, as: API

  @open_ai "open_ai"

  def edit_text(text) do
    "#{@open_ai}_edit_texts"
    |> API.client()
    |> Tesla.post("/edits", %{
      "model" => "text-davinci-edit-001",
      "input" => text,
      "n" => 1,
      "instruction" => "Fix the spelling mistakes"
    })
  end

  def generate_image_from_text(text) do
    "#{@open_ai}_edit_texts"
    |> API.client()
    |> Tesla.post("/images/generations", %{
      "model" => "text-davinci-edit-001",
      "input" => text,
      "n" => 1,
      "size" => "1024x1024"
    })
  end

  def correct_text_to_standard(text_to_standard) do
    "#{@open_ai}_correct_text_to_standard"
    |> API.client()
    |> Tesla.post("/completions", %{
      "model" => "text-davinci-003",
      "prompt" => "Correct this to standard English:\n\n#{text_to_standard}.",
      "temperature" => 0,
      "max_tokens" => 60,
      "top_p" => 1,
      "frequency_penalty" => 0,
      "presence_penalty" => 0
    })
  end

  def translate_from_english_to_three_languages(text, lang_1, lang_2, lang_3) do
    "#{@open_ai}_correct_text_to_standard"
    |> API.client()
    |> Tesla.post("/completions", %{
      "model" => "text-davinci-003",
      "prompt" =>
        "Translate this into 1. #{lang_1}, 2. #{lang_2} and 3. #{lang_3}:\n\n#{text}\n\n1.",
      "temperature" => 0.3,
      "max_tokens" => 100,
      "top_p" => 1,
      "frequency_penalty" => 0,
      "presence_penalty" => 0
    })
  end

  def search_text(text) do
    "#{@open_ai}_search_text"
    |> API.client()
    |> Tesla.post("/completions", %{
      "model" => "text-davinci-003",
      "prompt" => "#{text}:",
      "temperature" => 0.5,
      "max_tokens" => 150,
      "top_p" => 1.0,
      "n" => 1,
      "frequency_penalty" => 0.0,
      "presence_penalty" => 0.0
    })
  end

  # model="text-davinci-003",
  # prompt="Product description: A home milkshake maker\nSeed words: fast, healthy, compact.\nProduct names: HomeShaker, Fit Shaker, QuickShake, Shake Maker\n\nProduct description: A pair of shoes that can fit any foot size.\nSeed words: adaptable, fit, omni-fit.",
  # temperature=0.8,
  # max_tokens=60,
  # top_p=1.0,
  # frequency_penalty=0.0,
  # presence_penalty=0.0
  def code_converter(from, to, from_code) do
    "#{@open_ai}_edit_texts"
    |> API.client()
    |> Tesla.post("/completions", %{
      "model" => "code-davinci-002",
      "prompt" => "##{from} to #{to}:\n#{from}: \n#{Kernel.inspect(from_code)}\n\n#{to}:",
      "temperature" => 0,
      "max_tokens" => 200,
      "top_p" => 1,
      "frequency_penalty" => 0,
      "presence_penalty" => 0
    })
  end
end
