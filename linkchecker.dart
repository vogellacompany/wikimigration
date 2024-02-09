import 'dart:math';

import 'package:http/http.dart' as http;

import 'dart:io';

// ANSI escape code for red text
const red = '\x1B[31m';
// ANSI escape code for green text
const green = '\x1B[32m';
// ANSI escape code to reset color
const reset = '\x1B[0m';

// ANSI escape code for bold
const bold = '\x1B[1m';

// ANSI escape code for blue text
const blue = '\x1B[34m';
// ANSI escape code to reset formatting

void main(List<String> args) {
  List<String> rawUrls = [
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/Dropdown_Command.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/Problems_View_Example.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/Populating_a_dynamic_submenu.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/Toggle_Mark_Occurrences.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/Toggle_Button_Command.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/Radio_Button_Command.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/Update_checked_state.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/Search_Menu.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/IFile_objectContribution.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/TextEditor_viewerContribution.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/Widget_in_a_toolbar.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/RCP_removes_the_Project_menu.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/Workbench_wizard_contribution.md',
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Accessibility_Features.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Command_Core_Expressions.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Common_Navigator_Framework.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Eclipse4_RCP_Dependency_Injection.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Eclipse4_RCP_Contexts.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Eclipse4_RCP_EAS_List_of_All_Provided_Services.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Event_Model.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Event_Processing.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Eclipse4_RCP_FAQ.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/EclipsePluginDevelopmentFAQ.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Eclipse_Corner.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/JFace.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/JFaceDataBinding.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/JFaceSnippets.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/PlatformCommandFramework.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Platform_Expression_Framework.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Rich_Client_Platform.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Rich_Client_Platform/Rich_Client_Platform_FAQ.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Rich_Client_Platform/Rich_Client_Platform_How_to.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Rich_Client_Platform/Rich_Client_Platform_Book.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/CSS.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Evolving-Java-based-APIs.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/API_Central.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Coding_Conventions.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Eclipse_Doc_Style_Guide.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Javadoc.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/VersionNumbering.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Evolving-Java-based-APIs-2.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Evolving-Java-based-APIs-3.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/ApiRemovalProcess.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Eclipse_API_Central_Deprecation_Policy.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Progress_Reporting.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Status_Handling_Best_Practices.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Export-Package.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Provisional_API_Guidelines.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Naming_Conventions.md",
//    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Eclipse_Project_Update_Sites.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Internationalization.md",
    "https://raw.githubusercontent.com/eclipse-pde/eclipse.pde/master/docs/API_Tools.md",
    "https://raw.githubusercontent.com/eclipse-equinox/equinox/master/docs/Adaptor_Hooks.md",
  ];

  //
  List<String> faq = [
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/The_Official_Eclipse_FAQs.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_Eclipse.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_the_Eclipse_Platform.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Where_did_Eclipse_come_from.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_the_Eclipse_Foundation.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_can_my_users_tell_where_Eclipse_ends_and_a_product_starts.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_are_Eclipse_projects_and_technologies.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_propose_my_own_project.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Who_is_building_commercial_products_based_on_Eclipse.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_open_source_projects_are_based_on_Eclipse.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_academic_research_projects_are_based_on_Eclipse.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Who_uses_Eclipse_in_the_classroom.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_an_Eclipse_Innovation_Grant.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_Eclipse_newsgroups_are_available.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_get_access_to_Eclipse_newsgroups.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_Eclipse_mailing_lists_are_available.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_articles_on_Eclipse_have_been_written.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_books_have_been_written_on_Eclipse.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_report_a_bug_in_Eclipse.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_can_I_search_the_existing_list_of_bugs_in_Eclipse.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_do_I_do_if_my_feature_request_is_ignored.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Can_I_get_my_documentation_in_PDF_form,_please.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Where_do_I_find_documentation_for_a_given_extension_point.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_is_Eclipse_licensed.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Where_do_I_get_and_install_Eclipse.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_run_Eclipse.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_increase_the_heap_size_available_to_Eclipse.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Where_can_I_find_that_elusive_.log_file.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Does_Eclipse_run_on_any_Linux_distribution.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_I_unzipped_Eclipse,_but_it_won%27t_start._Why.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_upgrade_Eclipse.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_install_new_plug-ins.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Can_I_install_plug-ins_outside_the_main_install_directory.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_remove_a_plug-in.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_find_out_what_plug-ins_have_been_installed.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Where_do_I_get_help.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_report_a_bug.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_accommodate_project_layouts_that_don%27t_fit_the_Eclipse_model.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_new_in_Eclipse_3.0.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Is_Eclipse_3.0_going_to_break_all_of_my_old_plug-ins.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_prevent_my_plug-in_from_being_broken_when_I_update_Eclipse.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_get_started_if_I_am_new_to_Java_and_Eclipse.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_show/hide_files_like_classpath_in_the_Navigator.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_link_the_Navigator_with_the_currently_active_editor.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_use_the_keyboard_to_traverse_between_editors.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_can_I_rearrange_Eclipse_views_and_editors.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Why_doesn%27t_my_program_start_when_I_click_the_Run_button.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_turn_off_autobuilding_of_Java_code.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_hide_referenced_libraries_in_the_Package_Explorer.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Where_do_my_class_files_disappear_to.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_editor_keyboard_shortcuts_are_available.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_stop_the_Java_editor_from_showing_a_single_method_at_once.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_open_a_type_in_a_Java_editor.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_control_the_Java_formatter.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_choose_my_own_compiler.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_Java_refactoring_support_is_available.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_can_Content_Assist_make_me_the_fastest_coder_ever.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_can_templates_make_me_the_fastest_coder_ever.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_a_Quick_Fix.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_profile_my_Java_program.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_debug_my_Java_program.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_find_out_the_command-line_arguments_of_a_launched_program.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_hot_code_replace.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_set_a_conditional_breakpoint.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_find_all_Java_methods_that_return_a_String.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_can_I_view_in_the_Hierarchy_view.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_add_an_extra_library_to_my_project%27s_classpath.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_the_advantage_of_sharing_the_project_file_in_a_repository.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_the_function_of_the_.cvsignore_file.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_set_up_a_Java_project_to_share_in_a_repository.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Why_does_the_Eclipse_compiler_create_a_different_serialVersionUID_from_javac.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_a_plug-in.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_a_plug-in.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_use_the_plug-in_Manifest_Editor.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Why_doesn%27t_my_plug-in_build_correctly.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_run_my_plug-in_in_another_instance_of_Eclipse.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_causes_my_plug-in_to_build_but_not_to_load_in_a_runtime_workbench.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_My_runtime_workbench_runs,_but_my_plug-in_does_not_show._Why.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_add_images_and_other_resources_to_a_runtime_JAR_file.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Can_I_add_icons_declared_by_my_plugin.xml_in_the_runtime_JAR.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_When_does_PDE_change_a_plug-in%27s_Java_build_path.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_a_PDE_JUnit_test.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Where_can_I_find_the_Eclipse_plug-ins.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_find_a_particular_class_from_an_Eclipse_plug-in.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Why_do_I_get_a_%27plug-in_was_unable_to_load_class%27_error_when_I_activate_a_menu_or_toolbar_action.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_the_use_of_the_build.xml_file.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_prevent_my_build.xml_file_from_being_overwritten.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_When_is_the_build.xml_script_executed.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_declare_my_own_extension_point.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_find_all_the_plug-ins_that_contribute_to_my_extension_point.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Why_is_the_interface_for_my_new_extension_point_not_visible.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Can_my_extension_point_schema_contain_nested_elements.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_a_feature.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_synchronize_versions_between_a_feature_and_its_plug-in(s).md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_the_Update_Manager.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_an_update_site_(site.xml).md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Why_does_my_update_site_need_a_license.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_a_plug-in.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Do_I_use_plugin_or_plug-in.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_the_plug-in_manifest_file_(plugin.xml).md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_make_my_plug-in_connect_to_other_plug-ins.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_are_extensions_and_extension_points.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_an_extension_point_schema.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_find_out_more_about_a_certain_extension_point.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_When_does_a_plug-in_get_started.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Where_do_plug-ins_store_their_state.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_find_out_the_install_location_of_a_plug-in.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_the_classpath_of_a_plug-in.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_add_a_library_to_the_classpath_of_a_plug-in.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_can_I_share_a_JAR_among_various_plug-ins.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_use_the_context_class_loader_in_Eclipse.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Why_doesn%27t_Eclipse_play_well_with_Xerces.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_a_plug-in_fragment.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Can_fragments_be_used_to_patch_a_plug-in.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_a_configuration.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_find_out_whether_the_Eclipse_Platform_is_running.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Where_does_System.out_and_System.err_output_go.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_locate_the_owner_plug-in_from_a_given_class.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_does_OSGi_and_the_new_runtime_affect_me.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_a_dynamic_plug-in.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_make_my_plug-in_dynamic_enabled.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_make_my_plug-in_dynamic_aware.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_use_progress_monitors.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_use_a_SubProgressMonitor.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_use_the_platform_logging_facility.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_use_the_platform_debug_tracing_facility.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_load_and_save_plug-in_preferences.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_use_the_preference_service.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_a_preference_scope.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_use_IAdaptable_and_IAdapterFactory.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Does_the_platform_have_support_for_concurrency.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_prevent_two_jobs_from_running_at_the_same_time.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_the_purpose_of_job_families.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_find_out_whether_a_particular_job_is_running.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_can_I_track_the_lifecycle_of_jobs.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_a_repeating_background_task.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_SWT.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Why_does_Eclipse_use_SWT.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Can_I_use_SWT_outside_Eclipse_for_my_own_project.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_configure_an_Eclipse_Java_project_to_use_SWT.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_an_executable_JAR_file_for_a_stand-alone_SWT_program.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Are_there_any_visual_composition_editors_available_for_SWT.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Why_do_I_have_to_dispose_of_colors,_fonts,_and_images.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Why_do_I_get_an_invalid_thread_access_exception.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_get_a_Display_instance.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_prompt_the_user_to_select_a_file_or_a_directory.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_display_a_Web_page_in_SWT.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_embed_AWT_and_Swing_inside_SWT.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Where_can_I_find_more_information_on_SWT.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_a_viewer.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_are_content_and_label_providers.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_kinds_of_viewers_does_JFace_provide.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Why_should_I_use_a_viewer.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_sort_the_contents_of_a_viewer.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_filter_the_contents_of_a_viewer.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_use_properties_to_optimize_a_viewer.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_a_label_decorator.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_use_image_and_font_registries.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_a_wizard.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_specify_the_order_of_pages_in_a_wizard.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_can_I_reuse_wizard_pages_in_more_than_one_wizard.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Can_I_reuse_wizards_from_other_plug-ins.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_make_my_wizard_appear_in_the_UI.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_run_a_lengthy_process_in_a_wizard.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_launch_the_preference_page_that_belongs_to_my_plug-in.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_ask_a_simple_yes_or_no_question.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_inform_the_user_of_a_problem.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_a_dialog_with_a_details_area.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_set_the_title_of_a_custom_dialog.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_save_settings_for_a_dialog_or_wizard.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_to_decorate_a_TableViewer_or_TreeViewer_with_Columns.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_configure_my_Eclipse_project_to_use_stand-alone_JFace.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_deploy_a_stand-alone_JFace_application.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Pages,_parts,_sites,_windows:_What_is_all_this_stuff.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_find_out_what_object_is_selected.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_find_out_what_view_or_editor_is_selected.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_find_the_active_workbench_page.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_show_progress_on_the_workbench_status_line.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Why_should_I_use_the_new_progress_service.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_write_a_message_to_the_workbench_status_line.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_a_label_decorator_declaratively.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_add_label_decorations_to_my_viewer.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_make_the_workbench_shutdown.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_can_I_use_IWorkbenchAdapter_to_display_my_model_elements.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_my_own_preference_page.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_use_property_pages.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_open_a_Property_dialog.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_add_my_wizard_to_the_New,_Import,_or_Export_menu_categories.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Can_I_activate_my_plug-in_when_the_workbench_starts.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_an_image_registry_for_my_plug-in.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_use_images_defined_by_other_plug-ins.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_show_progress_for_things_happening_in_the_background.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_switch_from_using_a_Progress_dialog_to_the_Progress_view.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Can_I_make_a_job_run_in_the_UI_thread.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Are_there_any_special_Eclipse_UI_guidelines.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Why_do_the_names_of_some_interfaces_end_with_the_digit_2.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_a_new_perspective.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_can_I_add_my_views_and_actions_to_an_existing_perspective.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_show_a_given_perspective.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_the_difference_between_a_perspective_and_a_workbench_page.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_fixed_views_and_perspectives.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_a_view.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_the_difference_between_a_view_and_a_viewer.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_my_own_view.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_set_the_size_or_position_of_my_view.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Why_can%27t_I_control_when,_where,_and_how_my_view_is_presented.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_will_my_view_show_up_in_the_Show_View_menu.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_make_my_view_appear_in_the_Show_In_menu.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_add_actions_to_a_view%27s_menu_and_toolbar.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_make_a_view_respond_to_selection_changes_in_another_view.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_does_a_view_persist_its_state_between_sessions.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_open_multiple_instances_of_the_same_view.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_the_difference_between_a_view_and_an_editor.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_open_an_editor_programmatically.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_open_an_external_editor.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_dynamically_register_an_editor_to_handle_a_given_extension.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_switch_to_vi_or_emacs-style_key_bindings.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_my_own_editor.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_enable_the_Save_and_Revert_actions.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_enable_global_actions_such_as_Cut,_Paste,_and_Print_in_my_editor.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_hook_my_editor_to_the_Back_and_Forward_buttons.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_a_form-based_editor,_such_as_the_plug-in_Manifest_Editor.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_a_graphical_editor.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_make_an_editor_that_contains_another_editor.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Actions,_commands,_operations,_jobs:_What_does_it_all_mean.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_an_action_set.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_make_my_action_set_visible.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_add_actions_to_the_global_toolbar.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_add_menus_to_the_main_menu.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_add_actions_to_the_main_menu.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Why_are_some_actions_activated_without_a_target.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Where_can_I_find_a_list_of_existing_action_group_names.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_the_difference_between_a_command_and_an_action.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_associate_an_action_with_a_command.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_my_own_key-binding_configuration.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_provide_a_keyboard_shortcut_for_my_action.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_can_I_change_the_name_or_tooltip_of_my_action.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_hook_into_global_actions,_such_as_Copy_and_Delete.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_build_menus_and_toolbars_programmatically.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_make_menus_with_dynamic_contents.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_the_difference_between_a_toolbar_and_a_cool_bar.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_to_create_a_context_menu_%26_add_actions_to_the_same.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Can_other_plug-ins_add_actions_to_my_part%27s_context_menu.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_add_other_plug-ins%27_actions_to_my_menus.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_the_purpose_of_activities.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_add_activities_to_my_plug-in.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_activities_get_enabled.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_the_difference_between_perspectives_and_activities.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_an_Eclipse_application.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_an_application.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_the_minimal_Eclipse_configuration.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_a_Rich_Client_application.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_customize_the_menus_in_an_RCP_application.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_make_key_bindings_work_in_an_RCP_application.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Can_I_create_an_application_that_doesn%27t_have_views_or_editors.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_specify_where_application_data_is_stored.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Can_I_create_an_application_that_doesn%27t_have_a_data_location.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_an_Eclipse_product.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_an_Eclipse_product.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_the_difference_between_a_product_and_an_application.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_distribute_my_Eclipse_offering.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Can_I_use_an_installation_program_to_distribute_my_Eclipse_product.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Can_I_install_my_product_as_an_add-on_to_another_product.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Where_do_I_find_suitable_Eclipse_logos_and_wordmarks.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_When_do_I_need_to_write_a_plug-in_install_handler.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_support_multiple_natural_languages_in_my_plug-in_messages.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_replace_the_Eclipse_workbench_window_icon_with_my_own.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_write_my_own_eclipseexe_platform_launcher.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Who_shows_the_Eclipse_splash_screen.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_can_I_publish_partial_upgrades_(patches)_to_my_product.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_support_is_there_for_creating_custom_text_editors.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_I%27m_still_confused!_How_do_all_the_editor_pieces_fit_together.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_get_started_with_creating_a_custom_text_editor.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_use_the_text_document_model.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_a_document_partition.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_add_Content_Assist_to_my_editor.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_provide_syntax_coloring_in_an_editor.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_support_formatting_in_my_editor.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_insert_text_in_the_active_text_editor.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_the_difference_between_highlight_range_and_selection.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_change_the_selection_on_a_double-click_in_my_editor.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_use_a_model_reconciler.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_add_help_content_to_my_plug-in.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_provide_F1_help.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_contribute_help_contexts.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_can_I_generate_HTML_and_toc.xml_files.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_write_a_Search_dialog.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_implement_a_search_operation.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_display_search_results.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_can_I_use_and_extend_the_compare_infrastructure.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_a_Compare_dialog.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_a_compare_editor.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_can_I_run_an_infocenter_on_different_servers.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_are_resources_created.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Can_I_create_resources_that_don%27t_reside_in_the_file_system.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_the_difference_between_a_path_and_a_location.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_When_should_I_use_refreshLocal.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_my_own_tasks,_problems,_bookmarks,_and_so_on.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_can_I_be_notified_of_changes_to_the_workspace.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_prevent_builds_between_multiple_changes_to_the_workspace.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Why_should_I_add_my_own_project_nature.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Where_can_I_find_information_about_writing_builders.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_store_extra_properties_on_a_resource.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_can_I_be_notified_on_property_changes_on_a_resource.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_and_when_do_I_save_the_workspace.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_can_I_be_notified_when_the_workspace_is_being_saved.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Where_is_the_workspace_local_history_stored.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_can_I_repair_a_workspace_that_is_broken.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_support_does_the_workspace_have_for_team_tools.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_open_an_editor_on_a_file_in_the_workspace.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_open_an_editor_on_a_file_outside_the_workspace.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_open_an_editor_on_something_that_is_not_a_file.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Why_don%27t_my_markers_show_up_in_the_Tasks_view.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Why_don%27t_my_markers_appear_in_the_editor%27s_vertical_ruler.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_access_the_active_project.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_are_IWorkspaceRunnable,_IRunnableWithProgress,_and_WorkspaceModifyOperation.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_write_to_the_console_from_a_plug-in.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_prompt_the_user_to_select_a_resource.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Can_I_use_the_actions_from_the_Navigator_in_my_own_plug-in.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_APIs_exist_for_integrating_repository_clients_into_Eclipse.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_deploy_projects_to_a_server_and_keep_the_two_synchronized.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_the_difference_between_a_repository_provider_and_a_team_subscriber.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_a_launch_configuration.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_When_do_I_use_a_launch_delegate.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_Ant.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Why_can%27t_my_Ant_build_find_javac.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_add_my_own_external_tools.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_an_external_tool_builder.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_run_an_external_builder_on_my_source_files.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_react_to_changes_in_source_files.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_implement_an_Eclipse_builder.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Where_are_project_build_specifications_stored.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_add_a_builder_to_a_given_project.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_implement_an_incremental_project_builder.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_handle_setup_problems_for_a_given_builder.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_make_my_compiler_incremental.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Language_integration_phase_3:_How_do_I_edit_programs.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_write_an_editor_for_my_own_language.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_add_Content_Assist_to_my_language_editor.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_add_hover_support_to_my_text_editor.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_problem_markers_for_my_compiler.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_implement_Quick_Fixes_for_my_own_language.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_support_refactoring_for_my_own_language.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_an_Outline_view_for_my_own_language_editor.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Language_integration_phase_4:_What_are_the_finishing_touches.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_wizards_do_I_define_for_my_own_language.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_When_does_my_language_need_its_own_nature.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_When_does_my_language_need_its_own_perspective.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_add_documentation_and_help_for_my_own_language.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_support_source-level_debugging_for_my_own_language.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_eScript.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Language_integration_phase_1:_How_do_I_compile_and_build_programs.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_load_source_files_edited_outside_Eclipse.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_run_an_external_builder_on_my_source_files.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_implement_a_compiler_that_runs_inside_Eclipse.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_react_to_changes_in_source_files.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_implement_an_Eclipse_builder.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Where_are_project_build_specifications_stored.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_add_a_builder_to_a_given_project.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_implement_an_incremental_project_builder.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_handle_setup_problems_for_a_given_builder.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_make_my_compiler_incremental.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Language_integration_phase_2:_How_do_I_implement_a_DOM.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_implement_a_DOM_for_my_language.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_can_I_ensure_that_my_model_is_scalable.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Language_integration_phase_3:_How_do_I_edit_programs.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_write_an_editor_for_my_own_language.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_add_Content_Assist_to_my_language_editor.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_add_hover_support_to_my_text_editor.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_problem_markers_for_my_compiler.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_implement_Quick_Fixes_for_my_own_language.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_support_refactoring_for_my_own_language.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_an_Outline_view_for_my_own_language_editor.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_Language_integration_phase_4:_What_are_the_finishing_touches.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_wizards_do_I_define_for_my_own_language.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_When_does_my_language_need_its_own_nature.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_When_does_my_language_need_its_own_perspective.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_add_documentation_and_help_for_my_own_language.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_support_source-level_debugging_for_my_own_language.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_extend_the_JDT.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_the_Java_model.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_Java_elements.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_a_Java_project.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_manipulate_Java_code.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_a_working_copy.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_a_JDOM.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_an_AST.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_create_and_examine_an_AST.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_distinguish_between_internal_and_external_JARs_on_the_build_path.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_launch_a_Java_program.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_JUnit.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_How_do_I_participate_in_a_refactoring.md',
    'https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/FAQ/FAQ_What_is_LTK.md',
  ];

  int maxUrlLength = 10;
  // Determine the maximum length for the first column

  for (var url in faq) {
    maxUrlLength = max(maxUrlLength, url.length);
  }

  for (var url in faq) {
    checkLinks(url, maxUrlLength);
  }
}

Future<void> checkLinks(String url, int maxUrlLength) async {
  String internalLinkStart = extractLeadingUrl(url);

  List<String> failedLinks = [];
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // links
      var links = extractLinks(response.body);
      var linksInternal = extractMarkdownLinks(response.body);

      for (var element in linksInternal) {
        if (element.startsWith("./")) {
          element = element.substring(2, element.length);
        }
        links.add(internalLinkStart + element);
        // print("   " + internalLinkStart + element);
      }
      // links.addAll(linksInternal);

      for (var linkUrl in links) {
        final linkResponse = await http.get(Uri.parse(linkUrl));
        if (linkResponse.statusCode != 200) {
          failedLinks.add("$linkUrl returns " + " ${linkResponse.statusCode}");
        }
      }
    } else {
      print(
          'Error: Unable to fetch the $url webpage. Status code: ${response.statusCode}');
    }
  } catch (e) {
    failedLinks.add('$red Error: $e \u2718 Failure$reset');
    // print('$red Error: $e \u2718 Failure$reset');
  }
  if (failedLinks.isEmpty) {
    // print("${url.padRight(maxUrlLength)} $green\u2714 Success$reset");
  } else {
    print("${url.padRight(maxUrlLength)} $red\u2718 Failure$reset");
  }
  for (var failedLink in failedLinks) {
    print("$red$failedLink \u2718 $reset");
  }
}

List<String> extractLinks(String text) {
  // This regex pattern is designed to match http and https URLs.
  // It's a simplified pattern and may not cover all valid URLs intricacies.
  RegExp linkPattern = RegExp(
      r'(http|https):\/\/[a-zA-Z0-9\-.]+\.[a-zA-Z]{2,}\/?\S*',
      caseSensitive: false);

  // Use the RegExp to find matches in the input text.
  Iterable<RegExpMatch> matches = linkPattern.allMatches(text);

  // Map the matches to their string values.
  List<String> links = matches.map((match) => match.group(0)!).toList();

  // Map the matches to their string values, trimming a trailing ')' if present.
  links = matches.map((match) {
    String url = match.group(0)!;
    // Check if the URL ends with a ')' and trim it if so.
    if (url.endsWith(')')) {
      url = url.substring(0, url.length - 1);
    }

    if (url.endsWith(').') || url.endsWith('),')) {
      url = url.substring(0, url.length - 2);
    }
    return url;
  }).toList();

  return links;
}

List<String> extractMarkdownLinks(String text) {
  RegExp linkPattern = RegExp(r'\]\(((?!http).*?\.md)', multiLine: true);

  Iterable<Match> matches = linkPattern.allMatches(text);
  List<String> links = matches.map((match) => match.group(1)!).toList();

  return links;
}

String extractLeadingUrl(String url) {
  var uri = Uri.parse(url);
  var segments = uri.pathSegments;

  if (segments.isNotEmpty) {
    var lastSegment = segments.last;
    String result = url.substring(0, (url.length - lastSegment.length));

    return result;
  }

  return ''; // Return an empty string if the URL does not have path segments
}

void printSuccess() {
  // Unicode character for a heavy check mark
  print('\u2714 Success');
}

void printFailure() {
  // Unicode character for a heavy ballot x
  print('\u2718 Failure');
}
