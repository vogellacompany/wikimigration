

JFace Data Binding
==================

JFace Data Binding is a multi-threaded set of abstractions that allow for automated validation and synchronization of values between objects. This is commonly used for, but not limited to, the binding of user interface components to model attributes. The core concepts behind the project are [Observables](/Observables "Observables") and [Bindings](/Binding "Binding"). We provide IObservable implementations for SWT, JFace, and JavaBeans but the core is void of references to these in anticipation of implementations for other projects (e.g. EMF, Swing, etc.).

Contents
--------

*   [1 JFace Data Binding Introduction](#JFace-Data-Binding-Introduction)
*   [2 JFace Data Binding/Getting started](#JFace-Data-Binding/Getting-started)
*   [3 JFace Data Binding/Snippets](#JFace-Data-Binding/Snippets)
*   [4 JFace Data Binding/Observable](#JFace-Data-Binding/Observable)
*   [5 JFace Data Binding/Binding](#JFace-Data-Binding/Binding)
*   [6 JFace Data Binding/Data Binding Context](#JFace-Data-Binding/Data-Binding-Context)
*   [7 JFace Data Binding/Converter](#JFace-Data-Binding/Converter)
*   [8 JFace Data Binding/Validators](#JFace-Data-Binding/Validators)
*   [9 JFace Data Binding/Realm](#JFace-Data-Binding/Realm)
*   [10 JFace Data Binding/TrackedGetter](#JFace-Data-Binding/TrackedGetter)
*   [11 JFace Data Binding/Master Detail](#JFace-Data-Binding/MasterDetail)

<!-- 
| **JFace Data Binding** |
| :-: |
| **Home** |
| [How to Contribute](/JFace_Data_Binding/How_to_Contribute "JFace Data Binding/How to Contribute") |
| [FAQ](/JFace_Data_Binding/FAQ "JFace Data Binding/FAQ") |
| [Snippets](/JFace_Data_Binding/Snippets "JFace Data Binding/Snippets") |
| Concepts |
| [Binding](/JFace_Data_Binding/Binding "JFace Data Binding/Binding") |
| [Converter](/JFace_Data_Binding/Converter "JFace Data Binding/Converter") |
| [Observable](/JFace_Data_Binding/Observable "JFace Data Binding/Observable") |
| [Realm](/JFace_Data_Binding/Realm "JFace Data Binding/Realm") |

|   ### Tutorials & Presentations  *   [Getting Started](/JFace_Data_Binding/Getting_started "JFace Data Binding/Getting started") *   [Tutorial](http://www.vogella.com/articles/EclipseDataBinding/article.html) *   [Snippets](/JFace_Data_Binding/Snippets "JFace Data Binding/Snippets") *   [High-Level Description of Data Binding](/JFace_Data_Binding_Introduction "JFace Data Binding Introduction")  ### Concepts  *   [Observable](/JFace_Data_Binding/Observable "JFace Data Binding/Observable"): value, list, set, or map whose state changes can be observed *   [Binding](/JFace_Data_Binding/Binding "JFace Data Binding/Binding"): keeps the state of two observables in sync, uni- or bidirectional *   [Data Binding Context](/JFace_Data_Binding/Data_Binding_Context "JFace Data Binding/Data Binding Context"): a container for bindings *   [Converter](/JFace_Data_Binding/Converter "JFace Data Binding/Converter"): used by a binding to convert values *   [Validators](/JFace_Data_Binding/Validators "JFace Data Binding/Validators"): used by a binding to validate values *   [Realm](/JFace_Data_Binding/Realm "JFace Data Binding/Realm"): serializes access to observables (every observable belongs to a realm) *   [Tracked Getter](/JFace_Data_Binding/TrackedGetter "JFace Data Binding/TrackedGetter"): makes the system aware of observables that a piece of code depends on *   [Master-Detail](/JFace_Data_Binding/Master_Detail "JFace Data Binding/Master Detail"): used when you want to bind to attributes of the currently selected object, rather than a fixed object   |   ### Miscellaneous  *   [FAQ](/JFace_Data_Binding/FAQ "JFace Data Binding/FAQ") *   [fireChangeEvent() Blog](http://fire-change-event.blogspot.com/) *   [How to Contribute](/JFace_Data_Binding/How_to_Contribute "JFace Data Binding/How to Contribute") *   [Conformance Tests](/JFace_Data_Binding/Conformance_Tests "JFace Data Binding/Conformance Tests") *   [Binding to EMF](/JFace_Data_Binding/EMF "JFace Data Binding/EMF") *   [Binding to GWT (experimental work)](/JFace_Data_Binding/GWT "JFace Data Binding/GWT") *   [Binding to DOM (experimental work)](/JFace_Data_Binding/DOM "JFace Data Binding/DOM") *   [Binding to SSE (DOM, EMF, CSS) (experimental work)](/JFace_Data_Binding/SSE "JFace Data Binding/SSE") *   [Binding to Pojo (by using NOT BeansObservable) (experimental work)](/JFace_Data_Binding/PojoBindable "JFace Data Binding/PojoBindable") *   [JFace Databinding Validation with JSR-303 (experimental work)](/JFace_Data_Binding/JSR303BeanJFaceDatabindingValidation "JFace Data Binding/JSR303BeanJFaceDatabindingValidation")   |
| --- | --- |

Contact Us
----------

The [JFace newsgroup](http://www.eclipse.org/newsportal/thread.php?group=eclipse.platform.jface) is the place for discussions and questions relating to JFace Data Binding. When posting please prefix the subject with "\[DataBinding\]" to allow us to easily find posts related to the project.

Design discussions and bugs are located on [Eclipse bugzilla](https://bugs.eclipse.org/bugs/) with a the values...

Classification 

Eclipse

Product 

Platform

Component 

UI

Like posts to the newsgroup when logging bugs please prefix the summary with "\[DataBinding\]" to allow for easier identification.

Getting Involved
----------------

There are many ways to get involved with JFace Data Binding. To find out how you can contribute see [How to Contribute](/JFace_Data_Binding/How_to_Contribute "JFace Data Binding/How to Contribute").

Historical Documents
--------------------

*   [JFace Data Binding Webinar](https://admin.adobe.acrobat.com/_a300965365/p77464314/) _(The code in this presentation is slightly out of date - converters and validators are set up differently in the final 1.0 API.)_
*   [Dave and Boris's EclipseCon 2007 long talk and slides](/images/0/0c/Databinding.zip "Databinding.zip")(Slightly out of date)
*   [Dave Orme's EclipseCon 2006 Lightning Talk slides](/images/3/32/Databinding.pdf "Databinding.pdf") _(This presentation is outdated. The concepts are still relevant though.)_
*   [Original Design Document](/JFace_Data_Binding/Original_Design "JFace Data Binding/Original Design")
*   [Scenarios Document](/JFace_Data_Binding/Scenarios "JFace Data Binding/Scenarios")
*   [Bind](/JFace_Data_Binding/The_New_Binding_API "JFace Data Binding/The New Binding API"): A prototype for a new and improved binding API, which was never finished

Project Release Status
----------------------

JFace Data Binding 1.0 was released with Eclipse 3.3, [Europa](/Europa_Simultaneous_Release "Europa Simultaneous Release"). The Eclipse 3.3.1 release (Europa Fall Maintenance Release) contains a number of [bug fixes](https://bugs.eclipse.org/bugs/buglist.cgi?query_format=advanced&short_desc_type=allwordssubstr&short_desc=%5BDataBinding%5D&classification=Eclipse&product=Platform&component=UI&target_milestone=3.3.1&long_desc_type=allwordssubstr&long_desc=&bug_file_loc_type=allwordssubstr&bug_file_loc=&status_whiteboard_type=allwordssubstr&status_whiteboard=&keywords_type=allwords&keywords=&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&bug_id=&votes=&chfieldfrom=&chfieldto=Now&chfieldvalue=&cmdtype=doit&order=Reuse+same+sort+as+last+time&field0-0-0=noop&type0-0-0=noop&value0-0-0=). -->

# JFace Data Binding Introduction

Why JFace Data Binding?
-----------------------

Developing line of business applications as Eclipse Rich Client Platform applications presents a number of unique challenges.

*   How does one validate data entry when the number of possible interactions between validation rules rises proportional to the square of the number of data entry fields on an input form?

*   How does one avoid coding repetitive, dull, tedious, and error-prone SWT event handlers?

*   How can one improve reuse of data-driven user interfaces?

All of these concerns are improved upon by using JFace Data Binding.

### How does this work?

Traditionally, database-driven line of business applications are organized into tiers:

*   a database tier
*   a business or domain model tier
*   a presentation tier

The communication paths between these tiers are organized along the routes that data flows within and among these tiers.

Recently, Hibernate, EJB3, and Rails technologies have emerged as a means of automating the data flow between the business tier and the database tier.

By analogy, just as Hibernate helps automate the data flow between the business tier and the database tier, JFace Data Binding helps automate the data flow between the business tier and the presentation tier. It does this via a simple update to the model-view-controller pattern that enables us to create a set of completely generic and reusable controllers between the business model objects and the view (or presentation) tier.

JFace Data Binding from 4000 meters
-----------------------------------

Traditional object-oriented architectures use the model-view-controller pattern to persist changes in a user interface to a model. This architecture can be visualized as follows:

![Mvc.png](https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/images/Mvc.png)

This works the following way:

*   The view observes (listens to) the model for changes and redraws itself when it detects a change.
*   The controller observes (listens to) the view for change events.
*   When the controller detects an event that needs to cause a change, it is responsible for mutating the model, which implicitly refreshes the view because the view is listening to the model for changes.

There are a few problems with this pattern:

*   The view has to understand the model.
*   The controller has to understand both the view and the model.

Data binding is a recognition that most of the time, Text widgets are bound to single properties of objects, a radio group has a java.util.List or a java.util.Set of choices and its selection is bound to a single property of an object, and so on. Since we know that the data type in the business model tier has to match the data type in the GUI widget, we can build a generic mapping layer between POJOs and GUIs similar to the way Hibernate is a generic mapping layer between POJOs and databases.

In general, the architecture then looks like:

![Binding.png](https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/images/Binding.png)

The implementation is simple. The generic controller represents data binding. It listens to changes on both the model and on the GUI view. When a change in a property occurs in the model, it is automatically copied to the GUI. Similarly, when the user changes a value in the GUI, the change is automatically copied back to the model.

To make this concrete, let's look at an example:

Suppose the model object is an Integer property of an Employee object called "numberOfYearsWithFirm". This property is to be bound to an SWT Text control. Then:

*   The data type of the model object is "int".
*   The data type of the UI is "String" (the data type of the text property of the Text).

The controller simply listens to the model for changes in the "numberOfYearsWithFirm" property. Similarly, it listens to the SWT Text object for changes the user makes in the UI.

If the user changes the UI or the underlying model object changes, that change is copied to the other side, automatically applying any validation and/or data type conversion rules that are necessary to make the whole thing work.

For example, if the user changes the SWT Text object, the new String value is validated that it can be converted to an "int", the value is then converted to an "int", and the new integer value is then set in the model object.

# JFace Data Binding/Getting started

This page shows you how to create a simple example application using data binding that you can play with.

Contents
--------

*   [1 Setup](#Setup)
*   [2 Example Code](#Example-Code)
*   [3 Validation Results](#Validation-Results)
*   [4 Custom Converters and Validators](#Custom-Converters-and-Validators)

### Setup

1.  Download and install the Eclipse 3.3 SDK.
2.  Start the Eclipse SDK and select a new workspace directory. Close the Welcome view - the Package Explorer should now be showing but empty.
3.  Create a new plug-in project: Hit Ctrl+3, enter 'npip' (just the letters, not the quotes), hit Return.
4.  Enter a project name, for example 'GettingStarted'.
5.  Keep the default options (Target: Eclipse 3.3, plug-in will make contributions to UI, no RCP application) and click the Finish button.
6.  In the plug-in manifest editor, switch to the 'Dependencies' tab.
7.  Under 'Required Plug-ins', click 'Add...'.
8.  In the dialog, type '*databinding'. (Note the leading wildcard character.)
9.  Multi-select **org.eclipse.core.databinding**, **org.eclipse.core.databinding.beans**, **org.eclipse.core.databinding.property**, **org.eclipse.jface.databinding**, and **com.ibm.icu**, and click 'OK'.
10.  Save and then close the plug-in manifest editor.
11.  Create a new Java package (File > New > Package) and pick a name for it, e.g. 'starting'.
12.  Create a new Java class (File > New > Class) in that package, called 'GettingStarted'.

### Example Code

Copy the following example code - consisting of three parts - into the new class. Use 'Source > Organize Imports' to get the appropriate import statements (make sure to select the SWT types for Text, Button, and Label, and to select org.eclipse.core.databinding.observable.Realm).

Save the file and then select 'Run > Run As > Java Application'. Enter a numeric value in the text field and observe how the label is updated automatically. Click on the button to double the amount. You can also try entering a non-numeric value.

	public class GettingStarted {

	static Model model = new Model();
	
	static void init(Shell shell) {
		Text text = new Text(shell, SWT.BORDER);
		Label label = new Label(shell, SWT.NONE);

		Button button = new Button(shell, SWT.PUSH);
		button.setText("Double!");
		button.addSelectionListener(new SelectionAdapter() {
			public void widgetSelected(SelectionEvent e) {
				model.setAmount(model.getAmount() * 2);
			}
		});
		
		DataBindingContext dbc = new DataBindingContext();

		IObservableValue modelObservable = BeansObservables.observeValue(model, "amount");

		dbc.bindValue(SWTObservables.observeText(text, SWT.Modify), modelObservable, null, null);
		dbc.bindValue(SWTObservables.observeText(label), modelObservable, null, null);
		
		GridLayoutFactory.swtDefaults().generateLayout(shell);
	}

The above code assumes that a SWT Shell has already been created, and that there is a model object with an 'amount' property. Both will be implemented in the remaining two code pieces.

A text widget, a label, and a button are created within the shell. When the button is clicked, the model's amount will be doubled, using the getter and setter methods supported by the model object.

A data binding context is created. This is an object that will hold on to the bindings that you create. Bindings can be created between observable objects. In our example, we create one observable for our model object's property, and two observables on the UI side, one for the text, and another one for the label. The two 'null' arguments are for configuring validators or converters; by passing null, we will get default validators and converters. Note that the model property is of a numeric type while the text widget holds strings. Clearly, some kind of conversion is needed here.

	static class Model {
		private PropertyChangeSupport changeSupport = new PropertyChangeSupport(this);
		public void addPropertyChangeListener(String propertyName,
				PropertyChangeListener listener) {
			changeSupport.addPropertyChangeListener(propertyName, listener);
		}
		public void removePropertyChangeListener(String propertyName,
				PropertyChangeListener listener) {
			changeSupport.removePropertyChangeListener(propertyName, listener);
		}
		private int amount = 0;
		public void setAmount(int newAmount) {
			int oldAmount = this.amount;
			this.amount = newAmount;
			changeSupport.firePropertyChange("amount", oldAmount, newAmount);
		}
		public int getAmount() {
			return amount;
		}
	}
 
This is a pretty basic model class that conforms to the JavaBeans specification by delegating listener management to a PropertyChangeSupport object. For convenience, it is implemented as a static inner class. You can easily add more properties to the model class, but don't forget to implement public getters and setters for them, and to make appropriate calls to changeSupport.firePropertyChange() from all setters.

	public static void main(String\[\] args) {
		final Display display = new Display();
		Realm.runWithDefault(SWTObservables.getRealm(display), new Runnable() {
			public void run() {
				Shell shell = new Shell(display);
				init(shell);
				shell.pack();
				shell.open();
				while (!shell.isDisposed()) {
					if (!display.readAndDispatch())
						display.sleep();
				}
			}
		});
		display.dispose();
	}
}

This is the standard SWT event loop with one complication - a SWT _Realm_ is created and made the default realm for our application. Think of a Realm as an abstraction of SWT's UI thread. If everything in your application happens in the UI thread, you don't have to deal with Realms in your binding code. For more details on this, see the [FAQ](/JFace_Data_Binding/FAQ "JFace Data Binding/FAQ") or the wiki page that explains in detail what a [Realm](/JFace_Data_Binding/Realm "JFace Data Binding/Realm") is. If you are writing a plug-in for the Eclipse Platform, or a RCP application, you don't have to do this setup yourself - as of Eclipse 3.3, it is already part of the initialization code in **PlatformUI.createAndRunWorkbench()**.

### Validation Results

To see the results of the default validation, add the following to the GettingStarted class.

	Label errorLabel = new Label(shell, SWT.NONE);
	dbc.bindValue(SWTObservables.observeText(errorLabel),
			new AggregateValidationStatus(dbc.getBindings(),
					AggregateValidationStatus.MAX_SEVERITY), null, null);
 
This code adds another label for the validation message and binds it to an aggregated status obtained from all the bindings in the data binding context. You can also look at validation results for individual bindings if you keep a reference to the binding object returned from bindValue:

	// updated line follows:
	Binding b = dbc.bindValue(SWTObservables.observeText(text, SWT.Modify), modelObservable, null, null);

	Label individualErrorLabel = new Label(shell, SWT.NONE);
	dbc.bindValue(SWTObservables.observeText(individualErrorLabel), b.getValidationStatus(), null, null);


Note that b.getValidationStatus() returns an IObservableValue, not an IStatus object. It is a live value which can be observed; in this example, we are using it directly in another call to bindValue().

### Custom Converters and Validators

To configure your own converters and/or validators instead of the default ones, you would pass an instance of UpdateValueStrategy for each direction (UI>Model, Model>UI) instead of the null arguments to bindValue():

	// this is just an example of configuring an existing validator and converter:
	dbc.bindValue(SWTObservables.observeText(text, SWT.Modify), modelObservable,
		// UI to model:
		new UpdateValueStrategy().setAfterConvertValidator(anIntValidator),
		// model to UI:
		new UpdateValueStrategy().setConverter(anIntToStringConverter));
 
 
