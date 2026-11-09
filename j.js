function binarySearch(searchList, value) {
  let arrayPath = [];
  let left = 0;
  let right = searchList.length-1;
  let is_found = false;
  while (left <= right) {
    let mid = Math.floor((right + left) / 2);
    arrayPath.push(searchList[mid]);
    if(searchList[mid] == value) {
      is_found = true;
      return arrayPath;
    }
    if(value <searchList[mid]) {
      right = mid - 1;
    }else{
      left = mid + 1;
    }
  }
  if(is_found == false) {return 'Value Not Found';}
  return arrayPath;
}

const testArray = [
  0, 1, 2, 3, 4, 5, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22,
  23, 49, 70,
];

console.log(binarySearch(testArray, 6));
