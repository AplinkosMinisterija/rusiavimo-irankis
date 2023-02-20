class DatabaseConsts {
  DatabaseConsts._();

  static String DB_COLLECTION = 'list';
  static String DB_COLLECTION_SECOND = 'question_list';
  static String DB_COLLECTION_FINAL = 'last_stage';

  static String CATEGORY_NAME = 'category';
  static String CATEGORY_ID = 'category_id';
  static String CATEGORY_SUB_CATEGORY = 'sub_categories';
  static String SUB_NAME = 'name';
  static String SUB_CODE_ID = 'code_id';
  static String SUB_ITEMS = 'items';
  static String ITEMS_CODE = 'code';
  static String ITEMS_NAME = 'name';
  static String ITEMS_TYPE = 'type';

  static String SECOND_CATEGORY_TITLE = 'title';
  static String SECOND_CATEGORY_ID = 'id';
  static String SECOND_CATEGORY_CODES_LIST = 'codes_list';
  static String SECOND_CATEGORY_QUESTIONS = 'questions';
  static String SECOND_CATEGORY_IS_MOVABLE = 'move_to_third_stage';

  static String QUESTION_TITLE = 'question';
  static String QUESTION_IF_CORRECT = 'progress_correct_answer';
  static String QUESTION_IF_WRONG = 'if_wrong_move_to_next_stage';
  static String QUESTION_NEW_CODE = 'new_code';

  static String FINAL_QUESTIONS_TITLE = 'question';
  static String FINAL_QUESTIONS_IF_YES_GO_TO_STAGE = 'if_yes_ask_stage_with_id';
  static String FINAL_QUESTIONS_IF_NO_GO_TO_STAGE = 'if_no_ask_stage_with_id';
  static String FINAL_QUESTIONS_IF_NO_GET_TYPE = 'if_no_get_type';
  static String FINAL_QUESTIONS_IF_YES_GET_TYPE = 'if_yes_get_type';

  static String FINAL_ID = 'id';
  static String FINAL_TITLE = 'title';
  static String FINAL_QUESTIONS = 'questions';
}
