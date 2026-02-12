using Avalonia.Controls;
using Avalonia.Interactivity;
using Avalonia.Platform.Storage;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Threading.Tasks;
using TEdit5.ViewModels;
using TEdit.Terraria;

namespace TEdit5.Views;

public partial class MainWindow : Window
{
    protected MainWindowViewModel MainWindowViewModel => (MainWindowViewModel)this.DataContext!;

    public MainWindow()
    {
        InitializeComponent();
    }

    public async void LoadWorldButton_Clicked(object sender, RoutedEventArgs args)
    {
        try
        {
            Console.WriteLine("[DEBUG] LoadWorldButton_Clicked: entering");
            await OpenWorldDialog();
            Console.WriteLine("[DEBUG] LoadWorldButton_Clicked: done");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[DEBUG] LoadWorldButton_Clicked ERROR: {ex}");
        }
    }

    private async Task OpenWorldDialog()
    {
        Console.WriteLine("[DEBUG] OpenWorldDialog: start");
        var fileTypes = new List<FilePickerFileType>
        {
            new FilePickerFileType("World File")
            {
                Patterns = new [] { "*.wld" },
                AppleUniformTypeIdentifiers = new [] { "public.data" },
                MimeTypes = new []{ "application/octet-stream" }
            },
        };

        // Get top level from the current control. Alternatively, you can use Window reference instead.
        var topLevel = TopLevel.GetTopLevel(this)!;

        Console.WriteLine("[DEBUG] OpenWorldDialog: opening file picker");
        var files = await topLevel.StorageProvider.OpenFilePickerAsync(new FilePickerOpenOptions
        {
            Title = "Open World File",
            AllowMultiple = false,
            FileTypeFilter = fileTypes
        });

        Console.WriteLine($"[DEBUG] OpenWorldDialog: files.Count = {files.Count}");

        if (files.Count == 1)
        {
            var file = files[0];
            Console.WriteLine($"[DEBUG] OpenWorldDialog: loading {file.Name}");
            await LoadWorld(file);
            Console.WriteLine("[DEBUG] OpenWorldDialog: load complete");
        }
    }

    private async Task LoadWorld(IStorageFile file)
    {
        var progress = new Progress<ProgressChangedEventArgs>(ProgressChangedEventArgs =>
               {
                   MainWindowViewModel.ProgressPercentage = ProgressChangedEventArgs.ProgressPercentage;
                   MainWindowViewModel.ProgressText = ProgressChangedEventArgs.UserState?.ToString() ?? string.Empty;
               });

        await MainWindowViewModel.DocumentService.LoadWorldAsync(file, progress);

        ((IProgress<ProgressChangedEventArgs>)progress).Report(new ProgressChangedEventArgs(0, string.Empty));
    }
}
