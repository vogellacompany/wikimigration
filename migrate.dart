import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as htmlDom;
import 'package:html2md/html2md.dart' as html2md;
import 'dart:io';

void main(List<String> arguments) async {
  const String imagePageUrl = 'https://wiki.eclipse.org/';
  const String imageRepository = 'eclipse-platform/eclipse.platform';

  List<String> faq = [
    'https://wiki.eclipse.org/The_Official_Eclipse_FAQs',
    'https://wiki.eclipse.org//FAQ_What_is_Eclipse%3F',
    'https://wiki.eclipse.org//FAQ_What_is_the_Eclipse_Platform%3F',
    'https://wiki.eclipse.org//FAQ_Where_did_Eclipse_come_from%3F',
    'https://wiki.eclipse.org//FAQ_What_is_the_Eclipse_Foundation%3F',
    'https://wiki.eclipse.org//FAQ_How_can_my_users_tell_where_Eclipse_ends_and_a_product_starts%3F',
    'https://wiki.eclipse.org//FAQ_What_are_Eclipse_projects_and_technologies%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_propose_my_own_project%3F',
    'https://wiki.eclipse.org//FAQ_Who_is_building_commercial_products_based_on_Eclipse%3F',
    'https://wiki.eclipse.org//FAQ_What_open_source_projects_are_based_on_Eclipse%3F',
    'https://wiki.eclipse.org//FAQ_What_academic_research_projects_are_based_on_Eclipse%3F',
    'https://wiki.eclipse.org//FAQ_Who_uses_Eclipse_in_the_classroom%3F',
    'https://wiki.eclipse.org//FAQ_What_is_an_Eclipse_Innovation_Grant%3F',
    'https://wiki.eclipse.org//FAQ_What_Eclipse_newsgroups_are_available%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_get_access_to_Eclipse_newsgroups%3F',
    'https://wiki.eclipse.org//FAQ_What_Eclipse_mailing_lists_are_available%3F',
    'https://wiki.eclipse.org//FAQ_What_articles_on_Eclipse_have_been_written%3F',
    'https://wiki.eclipse.org//FAQ_What_books_have_been_written_on_Eclipse%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_report_a_bug_in_Eclipse%3F',
    'https://wiki.eclipse.org//FAQ_How_can_I_search_the_existing_list_of_bugs_in_Eclipse%3F',
    'https://wiki.eclipse.org//FAQ_What_do_I_do_if_my_feature_request_is_ignored%3F',
    'https://wiki.eclipse.org//FAQ_Can_I_get_my_documentation_in_PDF_form,_please%3F',
    'https://wiki.eclipse.org//FAQ_Where_do_I_find_documentation_for_a_given_extension_point%3F',
    'https://wiki.eclipse.org//FAQ_How_is_Eclipse_licensed%3F',
    'https://wiki.eclipse.org//FAQ_Where_do_I_get_and_install_Eclipse%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_run_Eclipse%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_increase_the_heap_size_available_to_Eclipse%3F',
    'https://wiki.eclipse.org//FAQ_Where_can_I_find_that_elusive_.log_file%3F',
    'https://wiki.eclipse.org//FAQ_Does_Eclipse_run_on_any_Linux_distribution%3F',
    'https://wiki.eclipse.org//FAQ_I_unzipped_Eclipse,_but_it_won%27t_start._Why%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_upgrade_Eclipse%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_install_new_plug-ins%3F',
    'https://wiki.eclipse.org//FAQ_Can_I_install_plug-ins_outside_the_main_install_directory%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_remove_a_plug-in%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_find_out_what_plug-ins_have_been_installed%3F',
    'https://wiki.eclipse.org//FAQ_Where_do_I_get_help%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_report_a_bug%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_accommodate_project_layouts_that_don%27t_fit_the_Eclipse_model%3F',
    'https://wiki.eclipse.org//FAQ_What_is_new_in_Eclipse_3.0%3F',
    'https://wiki.eclipse.org//FAQ_Is_Eclipse_3.0_going_to_break_all_of_my_old_plug-ins%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_prevent_my_plug-in_from_being_broken_when_I_update_Eclipse%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_get_started_if_I_am_new_to_Java_and_Eclipse%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_show/hide_files_like_classpath_in_the_Navigator%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_link_the_Navigator_with_the_currently_active_editor%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_use_the_keyboard_to_traverse_between_editors%3F',
    'https://wiki.eclipse.org//FAQ_How_can_I_rearrange_Eclipse_views_and_editors%3F',
    'https://wiki.eclipse.org//FAQ_Why_doesn%27t_my_program_start_when_I_click_the_Run_button%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_turn_off_autobuilding_of_Java_code%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_hide_referenced_libraries_in_the_Package_Explorer%3F',
    'https://wiki.eclipse.org//FAQ_Where_do_my_class_files_disappear_to%3F',
    'https://wiki.eclipse.org//FAQ_What_editor_keyboard_shortcuts_are_available%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_stop_the_Java_editor_from_showing_a_single_method_at_once%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_open_a_type_in_a_Java_editor%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_control_the_Java_formatter%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_choose_my_own_compiler%3F',
    'https://wiki.eclipse.org//FAQ_What_Java_refactoring_support_is_available%3F',
    'https://wiki.eclipse.org//FAQ_How_can_Content_Assist_make_me_the_fastest_coder_ever%3F',
    'https://wiki.eclipse.org//FAQ_How_can_templates_make_me_the_fastest_coder_ever%3F',
    'https://wiki.eclipse.org//FAQ_What_is_a_Quick_Fix%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_profile_my_Java_program%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_debug_my_Java_program%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_find_out_the_command-line_arguments_of_a_launched_program%3F',
    'https://wiki.eclipse.org//FAQ_What_is_hot_code_replace%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_set_a_conditional_breakpoint%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_find_all_Java_methods_that_return_a_String%3F',
    'https://wiki.eclipse.org//FAQ_What_can_I_view_in_the_Hierarchy_view%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_add_an_extra_library_to_my_project%27s_classpath%3F',
    'https://wiki.eclipse.org//FAQ_What_is_the_advantage_of_sharing_the_project_file_in_a_repository%3F',
    'https://wiki.eclipse.org//FAQ_What_is_the_function_of_the_.cvsignore_file%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_set_up_a_Java_project_to_share_in_a_repository%3F',
    'https://wiki.eclipse.org//FAQ_Why_does_the_Eclipse_compiler_create_a_different_serialVersionUID_from_javac%3F',
    'https://wiki.eclipse.org//FAQ_What_is_a_plug-in%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_a_plug-in%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_use_the_plug-in_Manifest_Editor%3F',
    'https://wiki.eclipse.org//FAQ_Why_doesn%27t_my_plug-in_build_correctly%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_run_my_plug-in_in_another_instance_of_Eclipse%3F',
    'https://wiki.eclipse.org//FAQ_What_causes_my_plug-in_to_build_but_not_to_load_in_a_runtime_workbench%3F',
    'https://wiki.eclipse.org//FAQ_My_runtime_workbench_runs,_but_my_plug-in_does_not_show._Why%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_add_images_and_other_resources_to_a_runtime_JAR_file%3F',
    'https://wiki.eclipse.org//FAQ_Can_I_add_icons_declared_by_my_plugin.xml_in_the_runtime_JAR%3F',
    'https://wiki.eclipse.org//FAQ_When_does_PDE_change_a_plug-in%27s_Java_build_path%3F',
    'https://wiki.eclipse.org//FAQ_What_is_a_PDE_JUnit_test%3F',
    'https://wiki.eclipse.org//FAQ_Where_can_I_find_the_Eclipse_plug-ins%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_find_a_particular_class_from_an_Eclipse_plug-in%3F',
    'https://wiki.eclipse.org//FAQ_Why_do_I_get_a_%27plug-in_was_unable_to_load_class%27_error_when_I_activate_a_menu_or_toolbar_action%3F',
    'https://wiki.eclipse.org//FAQ_What_is_the_use_of_the_build.xml_file%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_prevent_my_build.xml_file_from_being_overwritten%3F',
    'https://wiki.eclipse.org//FAQ_When_is_the_build.xml_script_executed%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_declare_my_own_extension_point%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_find_all_the_plug-ins_that_contribute_to_my_extension_point%3F',
    'https://wiki.eclipse.org//FAQ_Why_is_the_interface_for_my_new_extension_point_not_visible%3F',
    'https://wiki.eclipse.org//FAQ_Can_my_extension_point_schema_contain_nested_elements%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_a_feature%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_synchronize_versions_between_a_feature_and_its_plug-in(s)%3F',
    'https://wiki.eclipse.org//FAQ_What_is_the_Update_Manager%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_an_update_site_(site.xml)%3F',
    'https://wiki.eclipse.org//FAQ_Why_does_my_update_site_need_a_license%3F',
    'https://wiki.eclipse.org//FAQ_What_is_a_plug-in%3F',
    'https://wiki.eclipse.org//FAQ_Do_I_use_plugin_or_plug-in%3F',
    'https://wiki.eclipse.org//FAQ_What_is_the_plug-in_manifest_file_(plugin.xml)%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_make_my_plug-in_connect_to_other_plug-ins%3F',
    'https://wiki.eclipse.org//FAQ_What_are_extensions_and_extension_points%3F',
    'https://wiki.eclipse.org//FAQ_What_is_an_extension_point_schema%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_find_out_more_about_a_certain_extension_point%3F',
    'https://wiki.eclipse.org//FAQ_When_does_a_plug-in_get_started%3F',
    'https://wiki.eclipse.org//FAQ_Where_do_plug-ins_store_their_state%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_find_out_the_install_location_of_a_plug-in%3F',
    'https://wiki.eclipse.org//FAQ_What_is_the_classpath_of_a_plug-in%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_add_a_library_to_the_classpath_of_a_plug-in%3F',
    'https://wiki.eclipse.org//FAQ_How_can_I_share_a_JAR_among_various_plug-ins%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_use_the_context_class_loader_in_Eclipse%3F',
    'https://wiki.eclipse.org//FAQ_Why_doesn%27t_Eclipse_play_well_with_Xerces%3F',
    'https://wiki.eclipse.org//FAQ_What_is_a_plug-in_fragment%3F',
    'https://wiki.eclipse.org//FAQ_Can_fragments_be_used_to_patch_a_plug-in%3F',
    'https://wiki.eclipse.org//FAQ_What_is_a_configuration%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_find_out_whether_the_Eclipse_Platform_is_running%3F',
    'https://wiki.eclipse.org//FAQ_Where_does_System.out_and_System.err_output_go%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_locate_the_owner_plug-in_from_a_given_class%3F',
    'https://wiki.eclipse.org//FAQ_How_does_OSGi_and_the_new_runtime_affect_me%3F',
    'https://wiki.eclipse.org//FAQ_What_is_a_dynamic_plug-in%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_make_my_plug-in_dynamic_enabled%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_make_my_plug-in_dynamic_aware%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_use_progress_monitors%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_use_a_SubProgressMonitor%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_use_the_platform_logging_facility%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_use_the_platform_debug_tracing_facility',
    'https://wiki.eclipse.org//FAQ_How_do_I_load_and_save_plug-in_preferences%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_use_the_preference_service%3F',
    'https://wiki.eclipse.org//FAQ_What_is_a_preference_scope%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_use_IAdaptable_and_IAdapterFactory%3F',
    'https://wiki.eclipse.org//FAQ_Does_the_platform_have_support_for_concurrency%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_prevent_two_jobs_from_running_at_the_same_time%3F',
    'https://wiki.eclipse.org//FAQ_What_is_the_purpose_of_job_families%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_find_out_whether_a_particular_job_is_running%3F',
    'https://wiki.eclipse.org//FAQ_How_can_I_track_the_lifecycle_of_jobs%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_a_repeating_background_task%3F',
    'https://wiki.eclipse.org//FAQ_What_is_SWT%3F',
    'https://wiki.eclipse.org//FAQ_Why_does_Eclipse_use_SWT%3F',
    'https://wiki.eclipse.org//FAQ_Can_I_use_SWT_outside_Eclipse_for_my_own_project%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_configure_an_Eclipse_Java_project_to_use_SWT%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_an_executable_JAR_file_for_a_stand-alone_SWT_program%3F',
    'https://wiki.eclipse.org//FAQ_Are_there_any_visual_composition_editors_available_for_SWT%3F',
    'https://wiki.eclipse.org//FAQ_Why_do_I_have_to_dispose_of_colors,_fonts,_and_images%3F',
    'https://wiki.eclipse.org//FAQ_Why_do_I_get_an_invalid_thread_access_exception%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_get_a_Display_instance%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_prompt_the_user_to_select_a_file_or_a_directory%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_display_a_Web_page_in_SWT%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_embed_AWT_and_Swing_inside_SWT%3F',
    'https://wiki.eclipse.org//FAQ_Where_can_I_find_more_information_on_SWT%3F',
    'https://wiki.eclipse.org//FAQ_What_is_a_viewer%3F',
    'https://wiki.eclipse.org//FAQ_What_are_content_and_label_providers%3F',
    'https://wiki.eclipse.org//FAQ_What_kinds_of_viewers_does_JFace_provide%3F',
    'https://wiki.eclipse.org//FAQ_Why_should_I_use_a_viewer%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_sort_the_contents_of_a_viewer%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_filter_the_contents_of_a_viewer%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_use_properties_to_optimize_a_viewer%3F',
    'https://wiki.eclipse.org//FAQ_What_is_a_label_decorator%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_use_image_and_font_registries%3F',
    'https://wiki.eclipse.org//FAQ_What_is_a_wizard%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_specify_the_order_of_pages_in_a_wizard%3F',
    'https://wiki.eclipse.org//FAQ_How_can_I_reuse_wizard_pages_in_more_than_one_wizard%3F',
    'https://wiki.eclipse.org//FAQ_Can_I_reuse_wizards_from_other_plug-ins%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_make_my_wizard_appear_in_the_UI%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_run_a_lengthy_process_in_a_wizard%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_launch_the_preference_page_that_belongs_to_my_plug-in%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_ask_a_simple_yes_or_no_question%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_inform_the_user_of_a_problem%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_a_dialog_with_a_details_area%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_set_the_title_of_a_custom_dialog%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_save_settings_for_a_dialog_or_wizard%3F',
    'https://wiki.eclipse.org//FAQ_How_to_decorate_a_TableViewer_or_TreeViewer_with_Columns%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_configure_my_Eclipse_project_to_use_stand-alone_JFace%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_deploy_a_stand-alone_JFace_application%3F',
    'https://wiki.eclipse.org//FAQ_Pages,_parts,_sites,_windows:_What_is_all_this_stuff%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_find_out_what_object_is_selected%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_find_out_what_view_or_editor_is_selected%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_find_the_active_workbench_page%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_show_progress_on_the_workbench_status_line%3F',
    'https://wiki.eclipse.org//FAQ_Why_should_I_use_the_new_progress_service%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_write_a_message_to_the_workbench_status_line%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_a_label_decorator_declaratively%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_add_label_decorations_to_my_viewer%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_make_the_workbench_shutdown%3F',
    'https://wiki.eclipse.org//FAQ_How_can_I_use_IWorkbenchAdapter_to_display_my_model_elements%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_my_own_preference_page%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_use_property_pages%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_open_a_Property_dialog%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_add_my_wizard_to_the_New,_Import,_or_Export_menu_categories%3F',
    'https://wiki.eclipse.org//FAQ_Can_I_activate_my_plug-in_when_the_workbench_starts%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_an_image_registry_for_my_plug-in%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_use_images_defined_by_other_plug-ins%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_show_progress_for_things_happening_in_the_background%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_switch_from_using_a_Progress_dialog_to_the_Progress_view%3F',
    'https://wiki.eclipse.org//FAQ_Can_I_make_a_job_run_in_the_UI_thread%3F',
    'https://wiki.eclipse.org//FAQ_Are_there_any_special_Eclipse_UI_guidelines%3F',
    'https://wiki.eclipse.org//FAQ_Why_do_the_names_of_some_interfaces_end_with_the_digit_2%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_a_new_perspective%3F',
    'https://wiki.eclipse.org//FAQ_How_can_I_add_my_views_and_actions_to_an_existing_perspective%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_show_a_given_perspective%3F',
    'https://wiki.eclipse.org//FAQ_What_is_the_difference_between_a_perspective_and_a_workbench_page%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_fixed_views_and_perspectives%3F',
    'https://wiki.eclipse.org//FAQ_What_is_a_view%3F',
    'https://wiki.eclipse.org//FAQ_What_is_the_difference_between_a_view_and_a_viewer%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_my_own_view%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_set_the_size_or_position_of_my_view%3F',
    'https://wiki.eclipse.org//FAQ_Why_can%27t_I_control_when,_where,_and_how_my_view_is_presented%3F',
    'https://wiki.eclipse.org//FAQ_How_will_my_view_show_up_in_the_Show_View_menu%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_make_my_view_appear_in_the_Show_In_menu%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_add_actions_to_a_view%27s_menu_and_toolbar%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_make_a_view_respond_to_selection_changes_in_another_view%3F',
    'https://wiki.eclipse.org//FAQ_How_does_a_view_persist_its_state_between_sessions%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_open_multiple_instances_of_the_same_view%3F',
    'https://wiki.eclipse.org//FAQ_What_is_the_difference_between_a_view_and_an_editor%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_open_an_editor_programmatically%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_open_an_external_editor%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_dynamically_register_an_editor_to_handle_a_given_extension%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_switch_to_vi_or_emacs-style_key_bindings%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_my_own_editor%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_enable_the_Save_and_Revert_actions%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_enable_global_actions_such_as_Cut,_Paste,_and_Print_in_my_editor%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_hook_my_editor_to_the_Back_and_Forward_buttons%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_a_form-based_editor,_such_as_the_plug-in_Manifest_Editor%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_a_graphical_editor%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_make_an_editor_that_contains_another_editor%3F',
    'https://wiki.eclipse.org//FAQ_Actions,_commands,_operations,_jobs:_What_does_it_all_mean%3F',
    'https://wiki.eclipse.org//FAQ_What_is_an_action_set%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_make_my_action_set_visible%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_add_actions_to_the_global_toolbar%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_add_menus_to_the_main_menu%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_add_actions_to_the_main_menu%3F',
    'https://wiki.eclipse.org//FAQ_Why_are_some_actions_activated_without_a_target%3F',
    'https://wiki.eclipse.org//FAQ_Where_can_I_find_a_list_of_existing_action_group_names%3F',
    'https://wiki.eclipse.org//FAQ_What_is_the_difference_between_a_command_and_an_action%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_associate_an_action_with_a_command%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_my_own_key-binding_configuration%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_provide_a_keyboard_shortcut_for_my_action%3F',
    'https://wiki.eclipse.org//FAQ_How_can_I_change_the_name_or_tooltip_of_my_action%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_hook_into_global_actions,_such_as_Copy_and_Delete%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_build_menus_and_toolbars_programmatically%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_make_menus_with_dynamic_contents%3F',
    'https://wiki.eclipse.org//FAQ_What_is_the_difference_between_a_toolbar_and_a_cool_bar%3F',
    'https://wiki.eclipse.org//FAQ_How_to_create_a_context_menu_%26_add_actions_to_the_same%3F',
    'https://wiki.eclipse.org//FAQ_Can_other_plug-ins_add_actions_to_my_part%27s_context_menu%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_add_other_plug-ins%27_actions_to_my_menus%3F',
    'https://wiki.eclipse.org//FAQ_What_is_the_purpose_of_activities%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_add_activities_to_my_plug-in%3F',
    'https://wiki.eclipse.org//FAQ_How_do_activities_get_enabled%3F',
    'https://wiki.eclipse.org//FAQ_What_is_the_difference_between_perspectives_and_activities%3F',
    'https://wiki.eclipse.org//FAQ_What_is_an_Eclipse_application%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_an_application%3F',
    'https://wiki.eclipse.org//FAQ_What_is_the_minimal_Eclipse_configuration%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_a_Rich_Client_application%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_customize_the_menus_in_an_RCP_application%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_make_key_bindings_work_in_an_RCP_application%3F',
    'https://wiki.eclipse.org//FAQ_Can_I_create_an_application_that_doesn%27t_have_views_or_editors%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_specify_where_application_data_is_stored%3F',
    'https://wiki.eclipse.org//FAQ_Can_I_create_an_application_that_doesn%27t_have_a_data_location%3F',
    'https://wiki.eclipse.org//FAQ_What_is_an_Eclipse_product%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_an_Eclipse_product%3F',
    'https://wiki.eclipse.org//FAQ_What_is_the_difference_between_a_product_and_an_application%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_distribute_my_Eclipse_offering%3F',
    'https://wiki.eclipse.org//FAQ_Can_I_use_an_installation_program_to_distribute_my_Eclipse_product%3F',
    'https://wiki.eclipse.org//FAQ_Can_I_install_my_product_as_an_add-on_to_another_product%3F',
    'https://wiki.eclipse.org//FAQ_Where_do_I_find_suitable_Eclipse_logos_and_wordmarks%3F',
    'https://wiki.eclipse.org//FAQ_When_do_I_need_to_write_a_plug-in_install_handler%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_support_multiple_natural_languages_in_my_plug-in_messages%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_replace_the_Eclipse_workbench_window_icon_with_my_own%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_write_my_own_eclipseexe_platform_launcher%3F',
    'https://wiki.eclipse.org//FAQ_Who_shows_the_Eclipse_splash_screen%3F',
    'https://wiki.eclipse.org//FAQ_How_can_I_publish_partial_upgrades_(patches)_to_my_product%3F',
    'https://wiki.eclipse.org//FAQ_What_support_is_there_for_creating_custom_text_editors%3F',
    'https://wiki.eclipse.org//FAQ_I%27m_still_confused!_How_do_all_the_editor_pieces_fit_together%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_get_started_with_creating_a_custom_text_editor%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_use_the_text_document_model%3F',
    'https://wiki.eclipse.org//FAQ_What_is_a_document_partition%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_add_Content_Assist_to_my_editor%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_provide_syntax_coloring_in_an_editor%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_support_formatting_in_my_editor%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_insert_text_in_the_active_text_editor%3F',
    'https://wiki.eclipse.org//FAQ_What_is_the_difference_between_highlight_range_and_selection%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_change_the_selection_on_a_double-click_in_my_editor%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_use_a_model_reconciler%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_add_help_content_to_my_plug-in%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_provide_F1_help%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_contribute_help_contexts%3F',
    'https://wiki.eclipse.org//FAQ_How_can_I_generate_HTML_and_toc.xml_files%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_write_a_Search_dialog%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_implement_a_search_operation%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_display_search_results%3F',
    'https://wiki.eclipse.org//FAQ_How_can_I_use_and_extend_the_compare_infrastructure%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_a_Compare_dialog%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_a_compare_editor%3F',
    'https://wiki.eclipse.org//FAQ_How_can_I_run_an_infocenter_on_different_servers%3F',
    'https://wiki.eclipse.org//FAQ_How_are_resources_created%3F',
    'https://wiki.eclipse.org//FAQ_Can_I_create_resources_that_don%27t_reside_in_the_file_system%3F',
    'https://wiki.eclipse.org//FAQ_What_is_the_difference_between_a_path_and_a_location%3F',
    'https://wiki.eclipse.org//FAQ_When_should_I_use_refreshLocal%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_my_own_tasks,_problems,_bookmarks,_and_so_on%3F',
    'https://wiki.eclipse.org//FAQ_How_can_I_be_notified_of_changes_to_the_workspace%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_prevent_builds_between_multiple_changes_to_the_workspace%3F',
    'https://wiki.eclipse.org//FAQ_Why_should_I_add_my_own_project_nature%3F',
    'https://wiki.eclipse.org//FAQ_Where_can_I_find_information_about_writing_builders%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_store_extra_properties_on_a_resource%3F',
    'https://wiki.eclipse.org//FAQ_How_can_I_be_notified_on_property_changes_on_a_resource%3F',
    'https://wiki.eclipse.org//FAQ_How_and_when_do_I_save_the_workspace%3F',
    'https://wiki.eclipse.org//FAQ_How_can_I_be_notified_when_the_workspace_is_being_saved%3F',
    'https://wiki.eclipse.org//FAQ_Where_is_the_workspace_local_history_stored%3F',
    'https://wiki.eclipse.org//FAQ_How_can_I_repair_a_workspace_that_is_broken%3F',
    'https://wiki.eclipse.org//FAQ_What_support_does_the_workspace_have_for_team_tools%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_open_an_editor_on_a_file_in_the_workspace%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_open_an_editor_on_a_file_outside_the_workspace%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_open_an_editor_on_something_that_is_not_a_file%3F',
    'https://wiki.eclipse.org//FAQ_Why_don%27t_my_markers_show_up_in_the_Tasks_view%3F',
    'https://wiki.eclipse.org//FAQ_Why_don%27t_my_markers_appear_in_the_editor%27s_vertical_ruler%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_access_the_active_project%3F',
    'https://wiki.eclipse.org//FAQ_What_are_IWorkspaceRunnable,_IRunnableWithProgress,_and_WorkspaceModifyOperation%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_write_to_the_console_from_a_plug-in%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_prompt_the_user_to_select_a_resource%3F',
    'https://wiki.eclipse.org//FAQ_Can_I_use_the_actions_from_the_Navigator_in_my_own_plug-in%3F',
    'https://wiki.eclipse.org//FAQ_What_APIs_exist_for_integrating_repository_clients_into_Eclipse%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_deploy_projects_to_a_server_and_keep_the_two_synchronized%3F',
    'https://wiki.eclipse.org//FAQ_What_is_the_difference_between_a_repository_provider_and_a_team_subscriber%3F',
    'https://wiki.eclipse.org//FAQ_What_is_a_launch_configuration%3F',
    'https://wiki.eclipse.org//FAQ_When_do_I_use_a_launch_delegate%3F',
    'https://wiki.eclipse.org//FAQ_What_is_Ant%3F',
    'https://wiki.eclipse.org//FAQ_Why_can%27t_my_Ant_build_find_javac%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_add_my_own_external_tools%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_an_external_tool_builder%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_run_an_external_builder_on_my_source_files%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_react_to_changes_in_source_files%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_implement_an_Eclipse_builder%3F',
    'https://wiki.eclipse.org//FAQ_Where_are_project_build_specifications_stored%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_add_a_builder_to_a_given_project%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_implement_an_incremental_project_builder%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_handle_setup_problems_for_a_given_builder%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_make_my_compiler_incremental%3F',
    'https://wiki.eclipse.org//FAQ_Language_integration_phase_3:_How_do_I_edit_programs%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_write_an_editor_for_my_own_language%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_add_Content_Assist_to_my_language_editor%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_add_hover_support_to_my_text_editor%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_problem_markers_for_my_compiler%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_implement_Quick_Fixes_for_my_own_language%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_support_refactoring_for_my_own_language%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_an_Outline_view_for_my_own_language_editor%3F',
    'https://wiki.eclipse.org//FAQ_Language_integration_phase_4:_What_are_the_finishing_touches%3F',
    'https://wiki.eclipse.org//FAQ_What_wizards_do_I_define_for_my_own_language%3F',
    'https://wiki.eclipse.org//FAQ_When_does_my_language_need_its_own_nature%3F',
    'https://wiki.eclipse.org//FAQ_When_does_my_language_need_its_own_perspective%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_add_documentation_and_help_for_my_own_language%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_support_source-level_debugging_for_my_own_language%3F',
    'https://wiki.eclipse.org//FAQ_What_is_eScript%3F',
    'https://wiki.eclipse.org//FAQ_Language_integration_phase_1:_How_do_I_compile_and_build_programs%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_load_source_files_edited_outside_Eclipse%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_run_an_external_builder_on_my_source_files%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_implement_a_compiler_that_runs_inside_Eclipse%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_react_to_changes_in_source_files%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_implement_an_Eclipse_builder%3F',
    'https://wiki.eclipse.org//FAQ_Where_are_project_build_specifications_stored%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_add_a_builder_to_a_given_project%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_implement_an_incremental_project_builder%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_handle_setup_problems_for_a_given_builder%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_make_my_compiler_incremental%3F',
    'https://wiki.eclipse.org//FAQ_Language_integration_phase_2:_How_do_I_implement_a_DOM%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_implement_a_DOM_for_my_language%3F',
    'https://wiki.eclipse.org//FAQ_How_can_I_ensure_that_my_model_is_scalable%3F',
    'https://wiki.eclipse.org//FAQ_Language_integration_phase_3:_How_do_I_edit_programs%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_write_an_editor_for_my_own_language%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_add_Content_Assist_to_my_language_editor%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_add_hover_support_to_my_text_editor%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_problem_markers_for_my_compiler%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_implement_Quick_Fixes_for_my_own_language%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_support_refactoring_for_my_own_language%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_an_Outline_view_for_my_own_language_editor%3F',
    'https://wiki.eclipse.org//FAQ_Language_integration_phase_4:_What_are_the_finishing_touches%3F',
    'https://wiki.eclipse.org//FAQ_What_wizards_do_I_define_for_my_own_language%3F',
    'https://wiki.eclipse.org//FAQ_When_does_my_language_need_its_own_nature%3F',
    'https://wiki.eclipse.org//FAQ_When_does_my_language_need_its_own_perspective%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_add_documentation_and_help_for_my_own_language%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_support_source-level_debugging_for_my_own_language%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_extend_the_JDT%3F',
    'https://wiki.eclipse.org//FAQ_What_is_the_Java_model%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_Java_elements%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_a_Java_project%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_manipulate_Java_code%3F',
    'https://wiki.eclipse.org//FAQ_What_is_a_working_copy%3F',
    'https://wiki.eclipse.org//FAQ_What_is_a_JDOM%3F',
    'https://wiki.eclipse.org//FAQ_What_is_an_AST%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_create_and_examine_an_AST%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_distinguish_between_internal_and_external_JARs_on_the_build_path%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_launch_a_Java_program%3F',
    'https://wiki.eclipse.org//FAQ_What_is_JUnit%3F',
    'https://wiki.eclipse.org//FAQ_How_do_I_participate_in_a_refactoring%3F',
    'https://wiki.eclipse.org//FAQ_What_is_LTK%3F',
  ];

  List<String> wikiPageUrls = [
    'https://wiki.eclipse.org//Menu_Contributions/Dropdown_Command',
    'https://wiki.eclipse.org//Menu_Contributions/Problems_View_Example',
    'https://wiki.eclipse.org//Menu_Contributions/Populating_a_dynamic_submenu',
    'https://wiki.eclipse.org//Menu_Contributions/Toggle_Mark_Occurrences',
    'https://wiki.eclipse.org//Menu_Contributions/Toggle_Button_Command',
    'https://wiki.eclipse.org//Menu_Contributions/Radio_Button_Command',
    'https://wiki.eclipse.org//Menu_Contributions/Update_checked_state',
    'https://wiki.eclipse.org//Menu_Contributions/Search_Menu',
    'https://wiki.eclipse.org//Menu_Contributions/IFile_objectContribution',
    'https://wiki.eclipse.org//Menu_Contributions/TextEditor_viewerContribution',
    'https://wiki.eclipse.org//Menu_Contributions/Widget_in_a_toolbar',
    'https://wiki.eclipse.org//Menu_Contributions/RCP_removes_the_Project_menu',
    'https://wiki.eclipse.org//Menu_Contributions/Workbench_wizard_contribution',

    "https://wiki.eclipse.org/Menu_Contributions",
    "https://wiki.eclipse.org/Rich_Client_Platform/Text_Editor_Examples",
    "//https://wiki.eclipse.org/IRC_FAQ",
    // "https://wiki.eclipse.org/The_Official_Eclipse_FAQs",
    // "https://wiki.eclipse.org/Javadoc",
    // "https://wiki.eclipse.org/Eclipse/Repository_retention_policy",
    // "https://wiki.eclipse.org/Coding_Conventions",
    // "https://wiki.eclipse.org/Eclipse_Project_Update_Sites",
    // "https://wiki.eclipse.org/Eclipse_Doc_Style_Guide",
    // "https://wiki.eclipse.org/Eclipse/API_Central",
    // "https://wiki.eclipse.org/Internationalization",
    // "https://wiki.eclipse.org/How_to_add_things_to_the_Eclipse_doc",
    // "https://wiki.eclipse.org/Eclipse_Project_Update_Sites",
    // "https://wiki.eclipse.org/Eclipse/Repository_retention_policy",
    // // Ab hier platform UI
    // "https://wiki.eclipse.org/Platform_UI_Command_Design",
    // "https://wiki.eclipse.org/Platform_UI_Error_Handling",
    // "https://wiki.eclipse.org/Menu_Contributions",
    // "https://wiki.eclipse.org/Rich_Client_Platform/Text_Editor_Examples",
    // "https://wiki.eclipse.org/Managing_Multiple_Instances_of_a_View",
  ];

  clearOutput();

  for (var wikiPageUrl in wikiPageUrls) {
    var filename = extractLastSegmentWithoutExtension(wikiPageUrl);
    await creatMDDoc(wikiPageUrl, imagePageUrl, filename, imageRepository);
  }
}

Future<void> creatMDDoc(String wikiPageUrl, String imagePageUrl,
    String filename, String imageRepository) async {
  try {
    final response = await http.get(Uri.parse(wikiPageUrl));

    if (response.statusCode == 200) {
      final htmlDocument = htmlParser.parse(response.body);

      // extract and load images
      List<htmlDom.Element> images =
          htmlDocument.getElementsByClassName("image");

      for (var element in images) {
        var test = element.getElementsByTagName("img")[0].attributes['src'];
        // download image
        String imageUrl = imagePageUrl + test.toString();

        //  print(imageUrl);
        download(imageUrl);
      }

      String htmlDocumentString = htmlDocument.body?.innerHtml ?? '';
      String preTagsFixed = replacePreTags(htmlDocumentString);
      // Use html2md to convert HTML to markdown
      final String markdownContent = html2md.convert(preTagsFixed);

      // replace the header understore with hythen
      RegExp pattern = RegExp(r'\(#(.*?)\)');

      String headerReplaced =
          markdownContent.replaceAllMapped(pattern, (match) {
        return match.group(0)!.replaceAll(RegExp(r'[_]'), '-');
      });

      String result = convertFileLinks(headerReplaced, imageRepository);

      result = removeTrailingCharacters(result);

      String folderPath = 'docs/';

      // Create a Directory object
      Directory outputDirectory = Directory(folderPath);

      if (!outputDirectory.existsSync()) {
        // Create the folder
        outputDirectory.createSync(recursive: true);
      }

      Directory imageOutputPath = Directory(folderPath + "/images");

      if (!imageOutputPath.existsSync()) {
        // Create the folder
        imageOutputPath.createSync(recursive: true);
      }

      result = deleteUpToLine(result, '"Past revisions of this page [h]")');
      if (result.contains('[Categories]')) {
        result = deleteFromLine(result, '[Categories]');
      }
      if (result.contains('[Category]')) {
        result = deleteFromLine(result, '[Category]');
      }
      if (result.contains('Retrieved from "[')) {
        result = deleteFromLine(result, 'Retrieved from "[');
      }
      // Removing the FAQ reference
      if (result.contains('* * *')) {
        result = deleteFromLine(result, '* * *');
      }

      // String result = imagesLinksAdjusted;
      var file =
          await File(folderPath + filename + ".md").writeAsString(result);
      // Do something with the file.
      // The variable `markdownContent` now contains the markdown
      // representation of the Wiki page content
    } else {
      print(
          'Failed to load the Wiki page. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

String replacePreTags(String htmlContent) {
  // Replace opening <pre> with <pre><code>
  RegExp prePattern = RegExp(r'<pre .*?>');
  String updatedHtml = htmlContent.replaceAll(prePattern, '<pre><code>');

  // Replace closing </pre> with </code></pre>
  updatedHtml = updatedHtml.replaceAll('</pre>', '</code></pre>');

  return updatedHtml;
}

String convertFileLinks(String input, String imageRepository) {
  // Define the regular expression pattern
  RegExp pattern = RegExp(
      r'\[\!\[(.*?)\]\((/images/.+?/)([^/]+)\.(png|jpg|jpeg|gif)\)\]\(/File:(.*?)\.(png|jpg|jpeg|gif)\)');

  // Perform the replacement using replaceAllMapped
  return input.replaceAllMapped(
    pattern,
    (match) {
      String altText = match.group(1)!;
      String imagePath = match.group(2)!;
      String fileName = match.group(3)!;
      String extension = match.group(4)!;
      String originalFileName = match.group(5)!;
      String originalExtension = match.group(6)!;

      // Construct the new image URL
      String imageUrl =
          'https://raw.githubusercontent.com/$imageRepository/master/docs/images/$fileName.$originalExtension';

      return '![$altText]($imageUrl)';
    },
  );
}

String removeTrailingCharacters(String input) {
  // This regex matches strings that start with /FAQ and end before a space,
  // capturing the content to allow modification.
  RegExp regex = RegExp(r'(/FAQ\S+?)\s', multiLine: true);

  // This function will be used to process each match
  String replaceMatch(Match match) {
    String matchedText = match[1]!; // The captured string

    // Remove trailing underscores and URL encoded question marks
    String cleanedText = matchedText.replaceAll(RegExp(r'[_%3F]+$'), '');

    // Prepend '.' to '/FAQ' making it './FAQ' and append '.md'
    return '.${cleanedText}.md ';
  }

  // Replace all occurrences in the input string
  String result = input.replaceAllMapped(regex, replaceMatch);

  return result;
}

void download(String URL) {
  HttpClient client = new HttpClient();
  List<int> _downloadData = [];
  var filename = URL.split("/").last;

  var fileSave = new File('./docs/images/${filename}');
  client.getUrl(Uri.parse(URL)).then((HttpClientRequest request) {
    return request.close();
  }).then((HttpClientResponse response) {
    response.listen((d) => _downloadData.addAll(d), onDone: () {
      fileSave.writeAsBytes(_downloadData);
    });
  });
}

void clearOutputFolder(String folderPath) {
  // Create a Directory object for the "output" folder
  Directory outputDirectory = Directory(folderPath);

  // Check if the output folder exists
  if (outputDirectory.existsSync()) {
    // Get a list of all items (files and subdirectories) in the folder
    List<FileSystemEntity> content = outputDirectory.listSync();

    // Delete each item in the output folder
    for (var item in content) {
      item.deleteSync(recursive: true);
    }
  }
}

String deleteUpToLine(String input, String lineStart) {
  // Find the index of the line that starts with the specified text
  int startIndex = input.indexOf(lineStart);
  // If the line is not found, throw an exception
  if (startIndex == -1) {
    throw Exception('Line starting with "$lineStart" not found.');
  }

  // Return the substring starting from the index after the line
  return input.substring(startIndex + lineStart.length);
}

String deleteFromLine(String input, String lineStart) {
  // print(input.length);

  // Find the index of the line that starts with the specified text
  int endIndex = input.indexOf(lineStart);
  // If the line is not found, throw an exception
  if (endIndex == -1) {
    throw Exception('Line starting with "$lineStart" not found.');
  }

  // print(endIndex);
  // Return the substring starting from the index after the line
  return input.substring(0, endIndex);
}

String extractLastSegmentWithoutExtension(String url) {
  var uri = Uri.parse(url);
  var segments = uri.pathSegments;

  if (segments.isNotEmpty) {
    var lastSegment = segments.last;

    // Check and remove a trailing question mark before the file extension
    if (lastSegment.endsWith('?')) {
      lastSegment = lastSegment.substring(0, lastSegment.length - 1);
    }

    // Check and remove a trailing question mark before the file extension
    if (lastSegment.endsWith('_')) {
      lastSegment = lastSegment.substring(0, lastSegment.length - 1);
    }

    // Remove file extension if exists
    var indexOfDot = lastSegment.lastIndexOf('.');
    if (indexOfDot != -1) {
      return lastSegment.substring(0, indexOfDot);
    }

    return lastSegment;
  }

  return ''; // Return an empty string if the URL does not have path segments
}

void clearOutput() {
  String folderPath = 'docs/';
  // Delete the content of the "output" folder
  clearOutputFolder(folderPath);
}
