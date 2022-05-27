/**
 * Created by Ethan Sargent on 27/07/2021.
 */

class portalHelper
{
    static processFieldsFromFilter(recordToEvaluate, apiNameFilter, options)
    {
        let fieldList = [];
        let index = 0;
        let fields = recordToEvaluate.fields;
        if (!fields) return fieldList;
        apiNameFilter.forEach(fieldApiName =>
        {
            // console.log('pushing field ' + fieldApiName);
            let currentField = fields[fieldApiName];
            let label = currentField.label;
            let value = (currentField.value) ? currentField.value : '';
            let isDefault = portalHelper.isDefault(currentField);
            let isDate = portalHelper.isDate(currentField);
            let key = label + value + index;
            if (!options?.conditions || portalHelper.evaluateFieldConditions(recordToEvaluate, fieldApiName, options.conditions))
            {
                fieldList.push({
                    label: label,
                    value: value,
                    apiName: fieldApiName,
                    isDefault: isDefault,
                    isDate: isDate,
                    key: key
                });
            }
            index++;
        });
        return fieldList;
    }

    static evaluateFieldConditions (recordToEvaluate, fieldApiName, fieldConditions)
    {
        let fieldCondition = fieldConditions[fieldApiName];
        if (fieldCondition)
        {
            let boundCondition = fieldCondition.bind(this);
            return boundCondition(recordToEvaluate);
        }
        return true;

    }

    static isDate (field)
    {
        return field?.fieldType.toLowerCase() === 'date';
    }

    static isDefault (field)
    {
        if (!field.fieldType) return true;
        return field.fieldType.toLowerCase() !== 'date';
    }

    static getNumberFromCurrencyString(currencyString)
    {
        if (!currencyString) return undefined;
        let numberString = currencyString.substring(1, currencyString.length);
        numberString = numberString.replace(',', '');
        return parseFloat(numberString);
    }

    static toTitleCase(str)
    {
        let upper = true
        let newStr = ""
        if (!str) return str;
        for (let i = 0, l = str.length; i < l; i++)
        {
            // Note that you can also check for all kinds of spaces  with
            // str[i].match(/\s/)
            if (str[i] == " " || str[i] == "-")
            {
                upper = true
                newStr += str[i]
                continue
            }
            newStr += upper ? str[i].toUpperCase() : str[i].toLowerCase()
            upper = false
        }
        return newStr
    }


}


export {portalHelper}