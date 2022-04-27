void SomeFunction(SomeFunctionParamStruct parameters){
    var lines = parameters.lines;
    var lineCount = lines.Count;

    var lineIndexes = new int[lines.Count];
    for (int index=0; index < lineIndexes.Length; ++index) {
        lineIndexes[index] = index;
    }
    
    for (int index=0; index < lineCount; ++index){
        var lineIndex = lineIndexes[index];
        var line = lines[lineIndex];
    }
}