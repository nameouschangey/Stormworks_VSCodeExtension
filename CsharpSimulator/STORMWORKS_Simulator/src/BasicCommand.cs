using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;

namespace STORMWORKS_Simulator
{
    public class BasicCommand : ICommand
    {
        public event EventHandler CanExecuteChanged
        {
            add
            {
                CommandManager.RequerySuggested += value;
            }
            remove
            {
                CommandManager.RequerySuggested -= value;
            }
        }

        private Predicate<object> _CanExecute;
        private Action<object> _OnExecute;

        public BasicCommand(Action<object> onExecute)
            :this((o) => true, onExecute)
        {
        }

        public BasicCommand(Predicate<object> canExecute, Action<object> onExecute)
        {
            _CanExecute = canExecute;
            _OnExecute = onExecute;
        }

        public bool CanExecute(object parameter)
        {
            return _CanExecute(parameter);
        }

        public void Execute(object parameter)
        {
            _OnExecute(parameter);
        }
    }
}
