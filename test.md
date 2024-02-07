Menu Contributions
Placement examples that describe the proposed new way of placing menu items for 3.3. Please contribute comments and suggestions in the discussion area or on Bug 154130 -KeyBindings- Finish re-work of commands and key bindings.

Contents
1 Placement and visibility
2 Example Matrix
3 Menu XML
3.1 Declarative menus - some constraints
3.2 Menu URIs
3.2.1 menu:
3.2.2 toolbar:
3.2.3 popup:
3.3 Using Expressions in
3.4 Ideas that were considered but not implemented
3.4.1 Menu - JSR198
3.4.2 Menu - XUL
3.4.3 Expression Templates original suggestion
3.4.4 Another Expression Alternative: Specify Context at Extension Level
4 Updating the menu and toolbar appearance
4.1 UIElements represent each UI visible instance of a command
4.2 State associated with the command is propogated to UI visible elements
5 Work
5.1 Available in 3.3
5.2 Available in 3.3M5
5.3 Available in 3.3M4
5.4 Work still to be done
Placement and visibility
The 4 extension points that deal with menus now org.eclipse.ui.actionSets, org.eclipse.ui.viewActions, org.eclipse.ui.editorActions, and org.eclipse.ui.popupMenus specify both menu placement and their visibility criteria. In the new menu mechanism they are separate concepts, placement and visibility.

Example Matrix
A (hopefully) growing list of menu contribution examples.

Example	comments
Menu Contributions/Dropdown Command	Dropdown tool items can have their menus filled in using menu contributions
Menu Contributions/Problems View Example	An example showing how the Problems View might be converted
Menu Contributions/Populating a dynamic submenu	A menu contribution to populate a Problems View dynamic submenu
Menu Contributions/Toggle Mark Occurrences	Placing the toggle mark occurrences button
Menu Contributions/Toggle Button Command	Contribute a toggle state menu item thru commands
Menu Contributions/Radio Button Command	Similar to updating toggle state, you can create radio buttons using menu contributions
Menu Contributions/Update checked state	The active handler can update the checked state (and other attributes) of its button
Menu Contributions/Search Menu	Adding the Java Search options to the Search menu
Menu Contributions/IFile objectContribution	A menu contribution for context menus when the selection is an IFile
Menu Contributions/TextEditor viewerContribution	A menu contribution for the text editor context menu
Menu Contributions/Widget in a toolbar	A menu contribution adding a control into the main toolbar
Menu Contributions/RCP removes the Project menu	An RCP application removes the Project menu. Note: this will probably not be in 3.3
Menu Contributions/Workbench wizard contribution	Contributing workbench wizards to Menu
Menu XML
Declarative information ... this needs to be cleaned up.

Declarative menus - some constraints
Some constraints on the system:

Identifiers (id) for
elements must be globally unique.
Identifiers (id) for elements must be globally unique if they are specified.
You can reference a
by id.
If you are just creating menu items for your commands, you can leave them with only a command id. You don't have to specify an item id.
You can reference a for placement options (after, before, etc.) by id.
ids only have to be unique within that menu level. This is changed to name instead of id in 3.3M5.
You can provide a label attribute. If none is provided, it will take the command name.
In this design the item contains most of the same rendering information that did.
and can have clauses. If a menu's evaluates to false, we will never ask the items contained in that menu.
All of the displayable attributes are translatable.
The mnemonic is specified as you place your elements in their respective menus, since it is possible that the same command might need a different mnemonic depending on which menu it is placed. Also, when defaulting to command names, they don't contain any mnemonic information.
Menus cannot be re-used, and so they have an intrinsic id value. Separators are unique within one menu level, so they also contain their name.

Menu URIs
For location placement we need a path and placement modifier, and to specify how the paths are built. First pass we are going to look at URIs.

:[?]
scheme is about how to interpret the URI path. For example, menu, toolbar, popup, status (although status may be deprecated).

menu:
For menu: valid root ids will be any viewId for that view's menu, and org.eclipse.ui.main.menu for the main menu. Then specify the id of the menu this contribution applies to. The placement modifier helps position the menu contribution. ex: after=, where can be a separator name, menu id, or item id. An example of a path: menu:org.eclipse.search.menu?after=contextMenuActionsGroup

Since menu ids must be unique, you can specify your menu location relative to an existing id: menu:org.eclipse.search.menu?after=contextMenuActionsGroup

toolbar:
For toolbar: valid root ids will be any viewId for that view's toolbar, org.eclipse.ui.main.toolbar for the main toolbar, and any toolbar id that is contained in the main toolbar. Toolbars can support invisible separators. Toolbars in the main toolbar (technically a coolbar) can have ids as well as separators, but only one level. For example: toolbar:org.eclipse.ui.edit.text.actionSet.presentation?after=Presentation

In this example, Presentation is an invisible separator in the org.eclipse.ui.edit.text.actionSet.presentation toolbar.

The use of org.eclipse.ui.main.toolbar might change if all "main" toolbars have ids anyway, so the only options for interpretting the toolbar root is 1) the view toolbar or 2) an IDed main toolbar.

popup:
For popup: valid root ids are any registered context id (which defaults to the part id if no context menu id was given at registration time) and org.eclipse.ui.popup.any for all registered context menus. For example, to add to the default Text Editor context menu: popup:#TextEditorContext?after=additions

Popup submenus are treated like menu submenus, except the form continues to be popup:submenuId.

There will be constants defined for the ids that the eclipse workbench provides, probably in org.eclipse.ui.menus.MenuUtil.

Using Expressions in
In 3.3M6 an org.eclipse.core.expressions.definitions extension point was added. Used to define a core expression, the definition can then be referenced from other locations.

<extension point="org.eclipse.core.expressions.definitions">
  <definition id="com.example.context">
    <with variable="activeContexts">
       <iterate operator="or">
         <equals value="org.eclipse.ui.contexts.actionSet"/>
       </iterate>
    </with>
  </definition>
</extension>
This can be called in a core expression like activeWhen, enabledWhen, visibleWhen, etc using the reference element:

<reference definitionId="com.example.context"/>
Ideas that were considered but not implemented
These ideas were considered but not implemented.

Menu - JSR198
Note: for novelty purposes only.

For comparison, there is a JSR describing how IDEs can contribute menus. Below is a sample for 2 items:

org.eclipse.ui.views.problems.sorting.item from menu:org.eclipse.ui.views.ProblemView

org.eclipse.ui.views.problems.resolveMarker.item from popup:org.eclipse.ui.views.ProblemView

Sorting... S Change the Sort order org.eclipse.ui.views.problems.sorting Quick Fix Q $nl$/icons/full/elcl16/smartmode_co.gif org.eclipse.jdt.ui.edit.text.java.correction.assist.proposals org.eclipse.jdt.ui.edit.text.java.correction.assist.proposals
Group By G
Some thoughts:

the actions can only specify one icon
the actions can't *quite* link to our commands
the menus can't specify dynamic submenus
Menu - XUL
Note: for novelty purposes only.

For comparison, with Mozilla everywhere there is the probability eclipse will include xulrunner. Menu definitions that are consistent with XUL look like:

<keyset>
  <key id="paste-key" modifiers="accel" key="V" />
</keyset>
<menubar id="org.eclipse.ui.views.ProblemView">
  <menupopup id="org.eclipse.ui.views.ProblemView">
    <menuitem id="org.eclipse.ui.views.problems.sorting.item"
        accesskey="S"
        key="paste-key"
        label="Sorting..."
        oncommand="invokeCommand('org.eclipse.ui.views.problems.sorting')" />
    <menu id="org.eclipse.ui.views.problems.groupBy.menu"
        label="Group By"
        accesskey="G">
      <menupopup id="groupby.popup">
        <!-- this is where submenu items would go -->
      </menupopup>
    </menu>
  </menupopup>
</menubar>
XUL supports everything as a flavour of a DOM, and javascripting can drive your buttons to perform commands. I suspect the scripting would allow you to dynamically update menus (dynamic menus) on popup, depending on what events the DOM would report to you.

Expression Templates original suggestion
You can see that the , , and probably the are likely to be replicated over and over again. A possible option is some kind of expression template markup ... either in its own extension or supported by our UI extensions that can use core expressions.

Here's an example of using expression templates in its own extension point.

<extension point="org.eclipse.core.expression.templates">
  <expression id="isPartActive">
    <parameter id="partId" />
    <with variable="activePartId">
      <equals value="$partId" />
    </with>
  </expression>
  <expression id="isActionSetActive">
    <parameter id="actionSetId" />
    <with variable="activeContexts">
      <iterator operator="or">
        <equals value="$actionSetId" />
      </iterator>
    </with>
  </expression>
  <expression id="isContextActive">
    <parameter id="contextId" />
    <with variable="activeContexts">
      <iterator operator="or">
        <equals value="$contextId" />
      </iterator>
    </with>
  </expression>
  <expression id="isSelectionAvailable">
    <not>
      <count value="0" />
    </not>
  </expression>
</extension>
This could be used to simplify the handler definitions:

<extension point="org.eclipse.ui.handlers">
  <handler commandId="org.eclipse.ui.edit.copy"
      class="org.eclipse.ui.views.markers.internal.CopyMarkerHandler">
    <enabledWhen>
      <evaluate ref="isSelectionAvailable" />
    </enabledWhen>
    <activeWhen>
      <evaluate ref="isPartActive">
        <parameter id="partId" value="org.eclipse.ui.views.ProblemView" />
      </evaluate>
    </activeWhen>
  </handler>
</extension>
If we allow recursive template definitions, that would allow you to specify the concrete expression once and then reference it throughout your view.

<extension point="org.eclipse.core.expression.templates">
  <expression id="isProblemViewActive">
    <evaluate ref="isPartActive">
      <parameter id="partId" value="org.eclipse.ui.views.ProblemView" />
    </evaluate>
  </expression>
</extension>
<extension point="org.eclipse.ui.handlers">
  <handler commandId="org.eclipse.ui.edit.copy"
      class="org.eclipse.ui.views.markers.internal.CopyMarkerHandler">
    <enabledWhen>
      <evaluate ref="isSelectionAvailable" />
    </enabledWhen>
    <activeWhen>
      <evaluate ref="isProblemViewActive" />
    </activeWhen>
  </handler>
</extension>
This reduces the handler definition even more.

A similar option to reuse expressions as much as possible without turning them into their own procedural language would be to allow global definitions and then reuse them. No parameters and no expression composition:

<extension point="org.eclipse.core.expression.templates">
  <expression id="isProblemViewActive">
    <with variable="activePartId">
      <equals value="org.eclipse.ui.views.ProblemView" />
    </with>
  </expression>
  <expression id="isSelectionAvailable">
    <not>
      <count value="0" />
    </not>
  </expression>
</extension>
<extension point="org.eclipse.ui.handlers">
  <handler commandId="org.eclipse.ui.edit.copy"
      class="org.eclipse.ui.views.markers.internal.CopyMarkerHandler">
    <enabledWhen ref="isSelectionAvailable" />
    <activeWhen ref="isProblemViewActive" />
  </handler>
</extension>
Another Expression Alternative: Specify Context at Extension Level
Since enabledWhen and activeWhen specify context and the simple way to specify context in XML is enclosure, how about scoping context to the extension point rather than the handler:

<extension point="org.eclipse.ui.handlers">
  <enabledWhen>  <!-- context of all  handlers in this extension -->
    <not>
      <count value="0" />
    </not>
  </enabledWhen>
  <activeWhen>
    <with variable="activePartId">
      <equals value="org.eclipse.ui.views.ProblemView" />
    </with>
  </activeWhen>
  <handler commandId="org.eclipse.ui.edit.copy"
      class="org.eclipse.ui.views.markers.internal.CopyMarkerHandler" />
  <handler commandId="org.eclipse.ui.edit.paste"
      class="org.eclipse.ui.views.markers.internal.PasteMarkerHandler" />
  <handler commandId="org.eclipse.ui.edit.delete"
      class="org.eclipse.ui.views.markers.internal.RemoveMarkerHandler" />
  <handler commandId="org.eclipse.jdt.ui.edit.text.java.correction.assist.proposals"
      class="org.eclipse.ui.views.markers.internal.ResolveMarkerHandler" />
  <handler commandId="org.eclipse.ui.edit.selectAll"
      class="org.eclipse.ui.views.markers.internal.SelectAllMarkersHandler" />
  <handler commandId="org.eclipse.ui.file.properties"
      class="org.eclipse.ui.views.markers.internal.ProblemPropertiesHandler" />
</extension>
This gives compact markup without inventing a new language. Elements nested in the handler element could override the extension-wide settings.

Updating the menu and toolbar appearance
It was suggested in 3.2 that state on the command could be used to implement the old contribution story behaviours:

changing label text and tooltips
changing icons
changing enablement
setting the item state (like checked state)
In 3.3 the enablement is tied to the command, and for the other behaviours we've decided to go with UIElements approach.

UIElements represent each UI visible instance of a command
The command service keeps a list of registered UI elements, which can be updated by the active handler. The checked state can be updated through UIElement#setChecked(boolean); (note that updateElement below is from IElementUpdater):

private boolean isChecked() {
    return getStore().getBoolean(
            PreferenceConstants.EDITOR_MARK_OCCURRENCES);
}
 
public void updateElement(UIElement element, Map parameters) {
    element.setChecked(isChecked());
}
When the toggle handler runs, it can request that any UI elements have their appearance updated from its execute(*) method:

ICommandService service = (ICommandService) serviceLocator
        .getService(ICommandService.class);
service.refreshElements(IJavaEditorActionDefinitionIds.TOGGLE_MARK_OCCURRENCES, null);
State associated with the command is propogated to UI visible elements
First define the toggle mark occurrences command. Pretty straight forward, although it needs a "STYLE" state since it can be toggled. To allow handlers to update the label for the menu/toolbar items, we also add the "NAME" state.

<extension point="org.eclipse.ui.commands">
  <command categoryId="org.eclipse.jdt.ui.category.source"
      description="%jdt.ui.ToggleMarkOccurrences.description"
      id="org.eclipse.jdt.ui.edit.text.java.toggleMarkOccurrences"
      name="%jdt.ui.ToggleMarkOccurrences.name">
    <state id="NAME" class="org.eclipse.jface.menus.TextState" />
    <state id="STYLE" class="org.eclipse.jface.commands.ToggleState:true" />
  </command>
</extension>
Work
Progress in 3.3.

Available in 3.3
Ok green.gifthe editor action bar contributor solution. EditorActionBarContributor will not be deprecated, but is not used in the commands/handler story. Menu Contributions have visibility tied to an active editor id, and editor specific handlers can be created in the editor init() or createPartControl() method using the handler service from getPartSite().getService(IHandlerService.class).
Ok green.gifAttributes for : helpContextId, style to support radio buttons and check boxes
Ok green.gifaction sets as contexts - action sets are still defined using org.eclipse.ui.actionSets, and each actionSet generates an equivalent context. showing/hiding actionSets activates/deactivates the equivalent context.
Ok green.gifHow do we give Trim widgets/toolbar widgets "focus" for command and handlers? There was an IFocusService added in 3.3 that allows a trim control to register itself. When that control has focus, the control and the ID it registered with are provided in the global application context to core expressions and handlers. This is available, but might not be the optimal solution if you just want cut, copy, and paste to work.
Ok green.gifShortcuts to define reusable core expressions for , , and . This has been added as the org.eclipse.core.expressions.definitions extension point and the core expression element.
Ok green.gifthe mnemonic field for elements (decorating)
Ok green.gifdisplay any keybinding for elements (decorating)
Ok green.giftoolbar expressions
Available in 3.3M5
There is an example of the RCP Mail application template updated for 3.3M5 and converted to use the org.eclipse.ui.menus extension point as much as possible at Contribution Example.

Ok green.gifchanging the menu item or tool item state from a handler, like updating the label or tooltip or checked state. Commands can contain elements, but that is not appropriate to use for providing feedback to the user. This will be done by adapting a callback provided by the UI element.
Ok green.gifthe element should have a name not an id
Ok green.gifsupport creating radio button or checked menu items
Ok green.gifcreating new toolbars in the main coolbar/trim declaratively
Ok green.gifcreating new toolbars in the main coolbar/trim programmatically
Ok green.giforg.eclipse.ui.popup.any as a context menu contribution
Ok green.gifDrop down toolbar items
We also have action sets activating and de-activating contexts in 3.3M5, but we'll need to decide the proper action set story for 3.3M6

We are still working on the EditorActionBarContributor story. It seems like we might be able to deprecate it. Editor instances can instantiate handlers upon creation for each command they support.

Available in 3.3M4
The basic menu API will be available in 3.3M4. It includes both declarative org.eclipse.ui.menus extension point with core expression support for visibility, and a programmatic interface accessed through the IMenuService.

We support contributing to the main menu, and the view menu, view toolbar, and any IDed context menu. We support contributing to existing toolbars in the main coolbar, and contributing trim widgets.

Programmatically we support the following types of contributions:

MenuManager
CommandContributionItem
CompoundContributionItem
ControlContribution (in 3.3M5)
Separator
GroupMarker
There are some specific mappings of elements and attributes on Menus Extension Mapping.

Work still to be done
A list of behaviours not supported or shipped with 3.3.

validate and possibly optimize the context menu population story and lifecycle. Many context menus set remove all when shown.
migrate Marker views
migrate standard workbench actions - a few were done
Check enabled visibleWhen support
Shortcuts placed on submenu items (like CTRL+N) (decorating)
ensure full visibleWhen support in the MenuManagers - i.e. should empty menus display (empty)
do we want to manage trim with a TrimContributionManager? This removes the coolbar, but has RCP implications.
the menu override capability - does this tie into the Customize Perspective dialog and action sets
A set of default programmatic core expressions. For example, ActionContextExpression or ActivePartExpression
deprecate the 4 extension: actionSets, viewActions, editorActions, popupMenus
read old extensions in terms of new extension
convert platform UI extensions to new extension
migration guide - what are the most common migration paths for Action and IActionDelegate to Command/IHandler.
Attributes for : state for checkboxes and radio buttons
possibly provide an plugin.xml converter for actionSets to menus
possibly provide an Action -> Handler converter
Error.gifstatus manager contributions
Legend:

nothing - TBD
Glass.gif- investigating
Progress.gif- in progress
Ok green.gif- completed
Error.gif- dropped
