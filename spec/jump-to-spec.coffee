StepJumper = require "../lib/step-jumper"

describe "jumping", ->
  beforeEach ->
    @stepJumper = new StepJumper(" Given I_have_a_cheese")

  describe "stepTypeRegex", ->
    it "should match right step types", ->
      expect("step 'I_have_a_cheese' do".match(@stepJumper.stepTypeRegex())).toBeTruthy()
    it "should not match wrong step types", ->
      expect("user = User.find(1)".match(@stepJumper.stepTypeRegex())).toBeFalsy()

  describe "checkMatch", ->
    beforeEach ->
      @match1 =
        matchText: "Given(/^some other random crap$/)"
        range: [[10, 0], [15, 0]]
      @match2 =
        matchText: "Given(/^I have a cheese$/)"
        range: [[20, 0], [25, 0]]
      @scanMatch =
        filePath: "path/to/file"
        matches: [@match1, @match2]
    it "should return file and line", ->
      expect(@stepJumper.checkMatch(@scanMatch)).toEqual(["path/to/file", 20])
