using System;
using System.Collections.Generic;
using System.Linq;

public class Program
{
	public static void Main()
	{
		var text = "abc d defdef def def def def";
		var lines = new List<string>();
		var charsPerLine = 7;
		var index = 0;

		while (index < (text.Length - charsPerLine+1))
		{
			var nextIndex = text.LastIndexOf(" ", index + charsPerLine + 1, charsPerLine + 1) + 1;
			if (nextIndex == -1
				|| nextIndex > index + charsPerLine)
			{
				nextIndex = index + charsPerLine;
			}

			lines.Add(text.Substring(index, nextIndex - index));
			index = nextIndex;
		}

		if(index < text.Length)
        {
			lines.Add(text.Substring(index));
        }


		// strip that additional, final space 
		//lines[lines.Count - 1] = lines.Last().Substring(0, lines.Last().Length - 1);
		//if (lines.Last() == "")
		//{
		//	lines.RemoveAt(lines.Count - 1);
		//}

		foreach (var line in lines)
		{
			Console.WriteLine("[" + line + "]");
		}


	}
}
