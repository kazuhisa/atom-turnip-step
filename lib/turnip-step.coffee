StepJumper = require './step-jumper'

module.exports =
  turnipStepView: null

  activate: (state) ->
    atom.commands.add 'atom-workspace', 'turnip-step:jump-to-step': =>
      row = atom.workspace.getActiveTextEditor().getCursorBufferPosition().row
      currentLine = atom.workspace.getActiveTextEditor().lineTextForBufferRow(row)
      stepJumper = new StepJumper(currentLine)
      return unless stepJumper.prepositionOrAdverb
      options =
        paths: ["spec/steps/**/*.rb"]

      atom.workspace.scan stepJumper.stepTypeRegex(), options, (match) ->
        if foundMatch = stepJumper.checkMatch(match)
          [file, line] = foundMatch
          console.log("Found match at #{file}:#{line}")
          atom.workspace.open(file).done (editor) -> editor.setCursorBufferPosition([line, 0])


  deactivate: ->
    @turnipStepView.destroy()

  serialize: ->
    turnipStepViewState: @turnipStepView.serialize()
